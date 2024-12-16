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
