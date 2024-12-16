import 'dart:async';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skill_check_project/core/consts/app_res.dart';
import 'package:skill_check_project/core/consts/color_res.dart';

import '../../../../../../../core/consts/asset_res.dart';
import '../../../../../../../core/consts/style_res.dart';
import '../../../../../../../core/extensions/my_extensions.dart';
import '../../../../widgets/primary_button.dart';
import '../../../../widgets/primary_circle_button.dart';

class RecordPlayerWidget extends StatefulWidget {
  final String path;
  final VoidCallback onSendTap;
  final VoidCallback onDeleteTap;

  const RecordPlayerWidget(
      {super.key,
      required this.path,
      required this.onSendTap,
      required this.onDeleteTap});

  @override
  State<RecordPlayerWidget> createState() => _RecordPlayerWidgetState();
}

class _RecordPlayerWidgetState extends State<RecordPlayerWidget> {
  final PlayerController playerController = PlayerController();
  late StreamSubscription<int> _durationSubscription;
  late StreamSubscription<void> _completionSubscription;

  String currentDuration = "00:00";
  bool isPlaying = false;
  bool isFinished = false;

  @override
  void initState() {
    super.initState();
    _durationSubscription =
        playerController.onCurrentDurationChanged.listen((duration) {
      setState(() {
        currentDuration = formatDuration(duration);
      });
    });

    // Listen to audio completion
    _completionSubscription = playerController.onCompletion.listen((_) async {
      await playerController.seekTo(0); // Reset to the start
      setState(() {
        isPlaying = false;
        isFinished = true;
      });
    });

    playerController.onCurrentDurationChanged.listen((duration) {
      AppRes.logger.f("Current Duration: $duration");
    });

    playerController.onCompletion.listen((_) {
      AppRes.logger.f("Audio Completed");
    });
    playerController.onPlayerStateChanged.listen((state) {
      AppRes.logger.f("Player State Changed: ${state.name}");
      setState(() {
        isPlaying = state == PlayerState.playing;
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initPlayer();
  }

  List<double> waveformData = List.empty();
  late PlayerWaveStyle _playerWaveStyle;

  void _initPlayer() async {
    _playerWaveStyle = PlayerWaveStyle(
      scrollScale: 0.8,
      fixedWaveColor: AppColors.audioWaveUnfocusedColor,
      liveWaveColor: AppColors.audioWaveFocusedColor,
    );
    final samples = _playerWaveStyle
        .getSamplesForWidth(MediaQuery.of(context).size.width - 32 / 2);
    await playerController.preparePlayer(
        shouldExtractWaveform: true, path: widget.path, noOfSamples: samples);
    await playerController.setFinishMode(finishMode: FinishMode.pause);
    playerController.updateFrequency = UpdateFrequency.high;
    final data = await playerController.extractWaveformData(
        path: widget.path, noOfSamples: samples);
    setState(() {
      waveformData = data;
    });
  }

  @override
  void dispose() {
    _durationSubscription.cancel();
    _completionSubscription.cancel();
    playerController.dispose();
    super.dispose();
  }

  void _togglePlayPause() async {
    if (isFinished) {
      await playerController.seekTo(0); // Reset to start
      isFinished = false;
    }
    if (isPlaying) {
      await playerController.pausePlayer();
    } else {
      await playerController.startPlayer();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        14.verticalSpace,
        Container(
          height: 43.h,
          margin: EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10.r)),
            color: AppColors.white,
          ),
          child: AudioFileWaveforms(
            waveformData: waveformData,
            waveformType: WaveformType.fitWidth,
            playerWaveStyle: _playerWaveStyle,
            enableSeekGesture: true,
            continuousWaveform: true,
            margin: EdgeInsets.zero,
            padding: EdgeInsets.zero,
            size: Size(double.infinity, 39.25.h),
            playerController: playerController,
          ),
        ),
        27.verticalSpace,
        Text(
          currentDuration,
          textAlign: TextAlign.center,
          style: golosRegular.copyWith(fontSize: 18),
        ),
        27.verticalSpace,
        Container(
          padding: EdgeInsets.all(4.r),
          height: 101.h,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
          ),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 64.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(32)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    PrimaryCircleButton(
                      backgroundColor: AppColors.secondary,
                      iconColor: AppColors.primary,
                      iconPath: isPlaying ? AssetRes.icPause : AssetRes.icPlay,
                      onPressed: _togglePlayPause,
                    ),
                    8.horizontalSpace,
                    PrimaryButton(
                      title: "Yuborish",
                      width: MediaQuery.of(context).size.width - 152,
                      height: 64.h,
                      textStyle: golosMedium.copyWith(
                        fontSize: 14,
                        color: AppColors.white,
                      ),
                      onPressed: () async {
                        await playerController.pausePlayer();
                        widget.onSendTap();
                      },
                    ),
                    8.horizontalSpace,
                    PrimaryCircleButton(
                      backgroundColor: AppColors.secondary,
                      iconColor: AppColors.iconColor,
                      iconPath: AssetRes.icDelete,
                      onPressed: () async {
                        await playerController.stopPlayer();
                        widget.onDeleteTap();
                      },
                    ),
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
