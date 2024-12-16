import 'package:skill_check_project/features/main/data/models/recitation_entity.dart';
import 'package:skill_check_project/features/main/data/models/recitation_model.dart';

import '../../../../core/helpers/isar_helper.dart';
import '../../domain/repository/storage_repository.dart';

class StorageRepositoryImpl extends StorageRepository {
  final IsarHelper _isarHelper = IsarHelper();

  StorageRepositoryImpl();

  @override
  Future<bool> addRecitation(RecitationModel recitationModel) async {
    try {
      final entity = recitationModel.toEntity();
      await _isarHelper.addRecitation(entity);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<List<RecitationModel>> getAllRecitations() async {
    try {
      final entities = await _isarHelper.getAllRecitations();
      return entities.map((e) => e.toModel()).toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<RecitationModel?> getRecitationById(int id) async {
    try {
      final entity = await _isarHelper.getRecitation(id);
      return entity?.toModel();
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> updateRecitation(RecitationModel recitationModel) async {
    try {
      final entity = recitationModel.toEntity();
      await _isarHelper.updateRecitation(entity);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> deleteRecitation(int id) async {
    try {
      await _isarHelper.deleteRecitation(id);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> deleteAllRecitations(List<int> ids) async {
    try {
      await _isarHelper.deleteAllRecitations(ids);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> insertAllRecitations(List<RecitationModel> recitationModels) async {
    try {
      final entities = recitationModels.map((e) => e.toEntity()).toList();
      await _isarHelper.insertAllRecitations(entities);
      return true;
    } catch (e) {
      return false;
    }
  }
}
