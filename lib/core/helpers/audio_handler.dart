import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';

class AudioPlayerHandler extends BaseAudioHandler with SeekHandler {
  final _audioPlayer = AudioPlayer();

  AudioPlayerHandler() {
    _notifyAudioHandler();
  }

  Future<void> playMedia(String url) async {
    await _audioPlayer.setUrl(url);
    _audioPlayer.play();
    playbackState.add(playbackState.value.copyWith(
      processingState: AudioProcessingState.ready,
      playing: true,
    ));
  }

  void _notifyAudioHandler() {
    _audioPlayer.positionStream.listen((position) {
      playbackState.add(playbackState.value.copyWith(updatePosition: position));
    });
    _audioPlayer.playerStateStream.listen((state) {
      playbackState.add(playbackState.value.copyWith(
        playing: state.playing,
        processingState: state.processingState == ProcessingState.completed
            ? AudioProcessingState.completed
            : AudioProcessingState.ready,
      ));
    });
  }
}
