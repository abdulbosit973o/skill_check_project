import 'dart:async';
import 'dart:io';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:skill_check_project/core/consts/app_res.dart';
import 'package:skill_check_project/core/consts/asset_res.dart';
import 'package:skill_check_project/core/consts/color_res.dart';
import 'package:skill_check_project/core/consts/style_res.dart';
import 'package:skill_check_project/features/main/presentation/screens/recitation/widgets/wave_widget/audio_wave_widget.dart';
import 'package:skill_check_project/features/main/presentation/screens/recitation/widgets/wave_widget/wave_animation.dart';

import '../../../data/models/recording_state_enum.dart';
import '../../widgets/primary_app_bar.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/primary_circle_button.dart';

class RecitationScreen extends StatefulWidget {
  const RecitationScreen({super.key});

  @override
  State<RecitationScreen> createState() => _RecitationScreenState();
}

class _RecitationScreenState extends State<RecitationScreen> {
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
        AppRes.showSnackBar(context, "Microphone is ready.");
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
    Directory appDirectory = await getApplicationDocumentsDirectory();
    String filePath =
        '${appDirectory.path}/${DateTime.now().millisecondsSinceEpoch}.m4a';

    await _audioRecorder.start(
        path: filePath, const RecordConfig(encoder: AudioEncoder.wav));
    recorderController.record();

    setState(() {
      _recordingState = RecordingState.Recording;
      _seconds = 0;
      _recordDuration = "00:00";
    });
    _startTimer();
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
    String? filePath = await _audioRecorder.stop();
    if (filePath != null) {
      recorderController.stop();
      _recordFilePath = filePath;
      // widget.onSaved(filePath);
    }
    setState(() {
      _recordingState = RecordingState.Stopped;
      _recordDuration = "00:00";
      _seconds = 0;
    });
    _stopTimer();
  }

  void _stopAndClearRecording() async {
    await _audioRecorder.stop();
    recorderController.stop();
    setState(() {
      _recordingState = RecordingState.UnSet;
      _recordDuration = "00:00";
      _seconds = 0;
    });
    _stopTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        _seconds++;
        _recordDuration = _formatDuration(_seconds);
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
      body: Column(
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
              ? _recordingFinishedWidget()
              : _recordIsOn
                  ? _recordingWidget()
                  : _initialRecordWidget()
        ],
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
            _recordFinished = true;
            _recordIsOn = false;
          });
        })
      ],
    );
  }

  Widget _recordingFinishedWidget() {
    return Column(
      children: [
        14.verticalSpace,
        AudioWaveWidget(),
        27.verticalSpace,
        Text(
          "00:26",
          textAlign: TextAlign.center,
          style: golosRegular.copyWith(fontSize: 18),
        ),
        27.verticalSpace,
        Container(
          padding: EdgeInsets.all(4.r),
          height: 101.h,
          decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(32))),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 64,
                padding: EdgeInsets.only(left: 20, right: 12),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(32))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    PrimaryCircleButton(
                        backgroundColor: AppColors.secondary,
                        iconColor: AppColors.primary,
                        iconPath: AssetRes.icPlay,
                        onPressed: () {}),
                    8.horizontalSpace,
                    PrimaryButton(
                      title: "Yuborish",
                      height: 64,
                      textStyle: golosMedium.copyWith(
                          fontSize: 14, color: AppColors.white),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RecitationScreen()),
                        );
                      },
                    ),
                    8.horizontalSpace,
                    PrimaryCircleButton(
                        backgroundColor: AppColors.secondary,
                        iconColor: AppColors.iconColor,
                        iconPath: AssetRes.icDelete,
                        onPressed: () {
                          setState(() {
                            _recordFinished = false;
                          });
                        }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
