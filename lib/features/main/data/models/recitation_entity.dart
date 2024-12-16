import 'package:isar/isar.dart';
import 'package:skill_check_project/features/main/data/models/recitation_model.dart';
part 'recitation_entity.g.dart';

@Collection()
class RecitationEntity {
  Id id = Isar.autoIncrement; // Auto-incremented ID
  late String addedTime; // Non-nullable
  late String filePath; // Non-nullable
}

// Extension for RecitationModel to RecitationEntity
extension RecitationModelMapper on RecitationModel {
  RecitationEntity toEntity() {
    return RecitationEntity()
      ..id = id ?? Isar.autoIncrement // Handles null id
      ..addedTime = addedTime
      ..filePath = filePath;
  }
}

// Extension for RecitationEntity to RecitationModel
extension RecitationEntityMapper on RecitationEntity {
  RecitationModel toModel() {
    return RecitationModel(
      id: id,
      addedTime: addedTime,
      filePath: filePath,
    );
  }
}