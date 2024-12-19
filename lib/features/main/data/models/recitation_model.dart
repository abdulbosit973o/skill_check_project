import 'package:audio_waveforms/audio_waveforms.dart';

class RecitationModel {
  final int? id;
  final String addedTime;
  final String filePath;

  RecitationModel({
    this.id,
    required this.addedTime,
    required this.filePath,
  });

  RecitationModel copyWith({
    int? id,
    String? addedTime,
    String? filePath,
  }) {
    return RecitationModel(
      id: id ?? this.id,
      addedTime: addedTime ?? this.addedTime,
      filePath: filePath ?? this.filePath,
    );
  }

  @override
  String toString() {
    return 'RecitationModel(id: $id, addedTime: $addedTime, filePath: $filePath)';
  }
}

class RecitationUIModel {
  final RecitationModel recitationModel;
  bool isPlaying;
  final PlayerController playerController;

  RecitationUIModel({
    required this.recitationModel,
    this.isPlaying = false,
    required this.playerController,
  });

  void togglePlaying() {
    isPlaying = !isPlaying;
  }
}
