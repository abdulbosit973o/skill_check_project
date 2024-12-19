import 'dart:async';

import 'package:audio_waveforms/audio_waveforms.dart' as Wave;
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_audio/just_audio.dart';
import 'package:skill_check_project/features/main/data/models/recitation_model.dart';

import '../../../../../../core/consts/app_res.dart';
import '../../../../../../core/consts/asset_res.dart';
import '../../../../../../core/consts/color_res.dart';
import '../../../../../../core/consts/style_res.dart';
import '../../../../../../core/extensions/my_extensions.dart';
import '../../../widgets/primary_circle_button.dart';

class RecitationItemWidget extends StatefulWidget {
  final RecitationModel recitationModel;
  final PlayerController playerController;
  final bool isPlaying;
  final VoidCallback onPlay;
  final VoidCallback onPause;

  const RecitationItemWidget({
    super.key,
    required this.recitationModel,
    required this.playerController,
    required this.isPlaying,
    required this.onPlay,
    required this.onPause,
  });
  @override
  State<RecitationItemWidget> createState() => _RecitationItemWidgetState();
}

class WaveformExtractionParams {
  final String path;
  final int noOfSamples;

  WaveformExtractionParams({required this.path, required this.noOfSamples});
}

class _RecitationItemWidgetState extends State<RecitationItemWidget> {
  late StreamSubscription<int> _durationSubscription;
  late StreamSubscription<void> _completionSubscription;
  int? fileLengthInDuration;

  String currentDuration = "00:00";
  bool isPlaying = false;
  bool isFinished = false;
  double width = 0;

  @override
  void initState() {
    super.initState();

    _durationSubscription =
        widget.playerController.onCurrentDurationChanged.listen((duration) {
      setState(() {
        currentDuration = formatDuration(duration);
      });
    });

    _completionSubscription =
        widget.playerController.onCompletion.listen((_) async {
      await widget.playerController.seekTo(0); // Reset to the start
      setState(() {
        isPlaying = false;
        isFinished = true;
      });
      widget.onPause();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    width = (MediaQuery.sizeOf(context).width - 185);
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
    final samples = _playerWaveStyle.getSamplesForWidth(width);
    await widget.playerController.preparePlayer(
        shouldExtractWaveform: true,
        path: widget.recitationModel.filePath,
        noOfSamples: samples);
    fileLengthInDuration = widget.playerController.maxDuration;
    setState(() {});
    AppRes.logger.e(fileLengthInDuration);
    await widget.playerController.setFinishMode(finishMode: FinishMode.pause);

    widget.playerController.updateFrequency = UpdateFrequency.high;

    try {
      final data = await compute(
        extractWaveformDataInBackground,
        WaveformExtractionParams(
          path: widget.recitationModel.filePath,
          noOfSamples: samples,
        ),
      );
      setState(() {
        waveformData = data;
      });
    } catch (e) {
      debugPrint("Error extracting waveform data: $e");
    }
  }

  Future<List<double>> extractWaveformDataInBackground(
      WaveformExtractionParams params) async {
    final playerController = PlayerController();
    return await widget.playerController.extractWaveformData(
      path: params.path,
      noOfSamples: params.noOfSamples,
    );
  }

  @override
  void dispose() {
    _durationSubscription.cancel();
    _completionSubscription.cancel();
    widget.playerController.dispose();
    super.dispose();
  }

  void _togglePlayPause() async {
    if (isFinished) {
      await widget.playerController.seekTo(0); // Reset to start
      isFinished = false;
    }
    if (widget.isPlaying) {
      await widget.playerController.pausePlayer();
      widget.onPause();
    } else {
      widget.onPlay();
      await widget.playerController.startPlayer();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 82.h,
      margin: const EdgeInsets.only(left: 31),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppColors.background,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            children: [
              PrimaryCircleButton(
                  iconPath:
                      widget.isPlaying ? AssetRes.icPause : AssetRes.icPlay,
                  iconColor: AppColors.white,
                  height: 44.h,
                  width: 44.w,
                  backgroundColor: AppColors.audioWaveFocusedColor,
                  onPressed: _togglePlayPause),
              12.horizontalSpace,
              AudioFileWaveforms(
                waveformData: waveformData,
                waveformType: WaveformType.fitWidth,
                playerWaveStyle: _playerWaveStyle,
                enableSeekGesture: true,
                continuousWaveform: true,
                margin: EdgeInsets.zero,
                padding: EdgeInsets.zero,
                size: Size(width, 39.25.h),
                playerController: widget.playerController,
              ),
              12.horizontalSpace,
              Text(
                fileLengthInDuration != null
                    ? formatDuration(fileLengthInDuration!)
                    : "....",
                style: golosRegular.copyWith(
                    fontSize: 12.sp, color: AppColors.backIconColor),
              )
            ],
          ),
          Text(
            formatToCustomDateTime(widget.recitationModel.addedTime),
            style: golosRegular.copyWith(
                fontSize: 12.sp, color: AppColors.iconColor),
          )
        ],
      ),
    );
  }
}
