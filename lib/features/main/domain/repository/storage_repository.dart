import '../../data/models/recitation_model.dart';

abstract class StorageRepository {
  Future<bool> addRecitation(RecitationModel recitationModel);
  Future<List<RecitationModel>> getAllRecitations();
  Future<RecitationModel?> getRecitationById(int id);
  Future<bool> updateRecitation(RecitationModel recitationModel);
  Future<bool> deleteRecitation(int id);
  Future<bool> deleteAllRecitations(List<int> ids);
  Future<bool> insertAllRecitations(List<RecitationModel> recitationModels);
}