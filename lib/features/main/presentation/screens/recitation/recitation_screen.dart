import 'dart:async';
import 'dart:io';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:skill_check_project/core/consts/app_res.dart';
import 'package:skill_check_project/core/consts/asset_res.dart';
import 'package:skill_check_project/core/consts/color_res.dart';
import 'package:skill_check_project/core/consts/style_res.dart';
import 'package:skill_check_project/features/main/presentation/bloc/recitation/recitation_bloc.dart';
import 'package:skill_check_project/features/main/presentation/screens/recitation/widgets/wave_widget/audio_wave_widget.dart';
import 'package:skill_check_project/features/main/presentation/screens/recitation/widgets/wave_widget/wave_animation.dart';

import '../../../data/models/recording_state_enum.dart';
import '../../widgets/primary_app_bar.dart';
import '../../widgets/primary_circle_button.dart';

class RecitationScreen extends StatefulWidget {
  const RecitationScreen({super.key});

  @override
  State<RecitationScreen> createState() => _RecitationScreenState();
}

class _RecitationScreenState extends State<RecitationScreen> {
  final _bloc = RecitationBloc();
  bool _recordIsOn = false;
  bool _recordFinished = false;
  final _audioRecorder = AudioRecorder();
  String _recordDuration = "00:00";
  String? _recordFilePath;
  RecordingState _recordingState = RecordingState.UnSet;
  Timer? _timer;
  int _seconds = 0;
  final recorderController = RecorderController();

  @override
  void initState() {
    _checkPermission();
    super.initState();
  }

  Future<void> _checkPermission() async {
    await Permission.storage.request();
    bool hasPermission = await _audioRecorder.hasPermission();
    if (!hasPermission) {
      var status = await Permission.microphone.request();
      if (status.isGranted) {
        setState(() {
          _recordingState = RecordingState.Set;
        });
      } else if (status.isDenied) {
        AppRes.showSnackBar(context, "Microphone permission denied.");
      } else if (status.isPermanentlyDenied) {
        await openAppSettings();
      }
    } else {
      setState(() {
        _recordingState = RecordingState.Set;
      });
    }
  }

  Future<void> _onRecordButtonPressed() async {
    switch (_recordingState) {
      case RecordingState.Set:
        await _startRecording();
        break;
      case RecordingState.Recording:
        await _pauseRecording();
        break;
      case RecordingState.Paused:
        await _resumeRecording();
        break;
      case RecordingState.Stopped:
        await _startRecording();
        break;
      case RecordingState.UnSet:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text(
            'Please allow recording from settings.',
            style: golosMedium,
          )),
        );
        break;
    }
  }

  Future<void> _startRecording() async {
    try {
      Directory appDirectory = await getApplicationDocumentsDirectory();

      Directory recordingsDirectory =
          Directory('${appDirectory.path}/Recordings');
      if (!await recordingsDirectory.exists()) {
        await recordingsDirectory.create();
      }

      Directory quranDirectory = Directory('${recordingsDirectory.path}/Quran');
      if (!await quranDirectory.exists()) {
        await quranDirectory.create();
      }

      String filePath =
          '${quranDirectory.path}/${DateTime.now().millisecondsSinceEpoch}.m4a';

      await _audioRecorder.start(
          path: filePath, const RecordConfig(encoder: AudioEncoder.wav));
      recorderController.record();

      setState(() {
        _recordingState = RecordingState.Recording;
        _seconds = 0;
        _recordDuration = "00:00";
      });

      _startTimer();
    } catch (e) {
      print('Recordingni boshlashda xatolik yuz berdi: $e');
    }
  }

  Future<void> _pauseRecording() async {
    await _audioRecorder.pause();
    recorderController.pause();
    setState(() {
      _recordingState = RecordingState.Paused;
    });
    _stopTimer();
  }

  Future<void> _resumeRecording() async {
    await _audioRecorder.resume();
    recorderController.record();
    setState(() {
      _recordingState = RecordingState.Recording;
    });
    _startTimer();
  }

  Future<void> _stopAndSaveRecording() async {
    if (_seconds < 3) {
      AppRes.showSnackBar(context, "Qiroat kamida 10 soniya bo'lishi kerak.");
      return;
    }

    String? filePath = await _audioRecorder.stop();
    if (filePath != null) {
      _recordFilePath = filePath;
      AppRes.logger.i(_recordFilePath);

      recorderController.stop();
      setState(() {
        _recordingState = RecordingState.Stopped;
        _recordDuration = "00:00";
        _seconds = 0;
        _recordFinished = true;
        _recordIsOn = false;
      });
      _stopTimer();
    }
  }


  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        _seconds++;
        _recordDuration = _formatDuration(_seconds);
        if (_seconds >= 120) {
          _stopAndSaveRecording();
        }
      });
    });
  }

  void _stopTimer() {
    _timer?.cancel();
  }

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _audioRecorder.dispose();
    _stopTimer();
    recorderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider.value(
        value: _bloc,
        child: BlocConsumer<RecitationBloc, RecitationState>(
          listener: (context, state) {
            if (state is RecitationError) {
              AppRes.showSnackBar(context, state.errorText);
            }
            if (state is RecitationSuccess) {
              AppRes.showSnackBar(context, "Muvaffaqiyatli qo'shildi !");
              Navigator.pop(context, true);
            }
          },
          builder: (context, state) {
            return Column(
              children: [
                SafeArea(
                    child: primaryAppBar(context, onBackPressed: () {
                  Navigator.pop(context);
                }, title: "Fotiha Surasini qiroat qilish")),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    AssetRes.cardImage,
                    colorBlendMode: BlendMode.darken,
                    color: AppColors.background,
                  ),
                ),
                _recordFinished
                    ? RecordPlayerWidget(
                        path: _recordFilePath!,
                        onSendTap: () {
                          _bloc.add(
                              AddRecitationEvent(filePath: _recordFilePath!));
                        },
                        onDeleteTap: () {
                          AppRes.logger.t("onDeleteTap ");
                          setState(() {
                            _recordIsOn = false;
                            _recordFinished = false;
                          });
                        },
                      )
                    : _recordIsOn
                        ? _recordingWidget()
                        : _initialRecordWidget()
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _initialRecordWidget() {
    return Column(
      children: [
        Text(
          "Qiroatni yozib yuborish uchun quyidagi\ntugmani 1 marta bosing",
          textAlign: TextAlign.center,
          style: golosMedium.copyWith(fontSize: 14),
        ),
        8.verticalSpace,
        Text(
          "Qiroatni 10dan 120 sekundgacha yuboring",
          textAlign: TextAlign.center,
          style: golosRegular.copyWith(
              fontSize: 12, color: AppColors.secondaryTextColor),
        ),
        18.verticalSpace,
        PrimaryCircleButton(
          onPressed: () {
            _onRecordButtonPressed();
            setState(() {
              _recordIsOn = true;
            });
          },
          iconPath: AssetRes.icMicrophone,
          width: 88.w,
          height: 88.h,
        ),
      ],
    );
  }

  Widget _recordingWidget() {
    return Column(
      children: [
        22.verticalSpace,
        Text(
          _recordDuration,
          textAlign: TextAlign.center,
          style: golosRegular.copyWith(fontSize: 18),
        ),
        38.verticalSpace,
        WaveAnimation(onTap: () {
          setState(() {
            _stopAndSaveRecording();
          });
        })
      ],
    );
  }
}
