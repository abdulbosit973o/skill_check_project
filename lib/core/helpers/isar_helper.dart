import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:skill_check_project/features/main/data/models/recitation_entity.dart';

class IsarHelper {
  late Future<Isar> db;
  static Isar? _isarInstance;

  IsarHelper() {
    db = _initDb();
  }

  Future<Isar> _initDb() async {
    if (_isarInstance != null) {
      return _isarInstance!;
    }

    final dir = await getApplicationDocumentsDirectory();

    _isarInstance = await Isar.open(
      [
        RecitationEntitySchema,
      ],
      directory: dir.path,
    );

    return _isarInstance!;
  }

  Future<int> addRecitation(RecitationEntity type) async {
    final isar = await db;
    return await isar.writeTxn<int>(() async {
      return await isar.recitationEntitys.put(type);
    });
  }

  Future<RecitationEntity?> getRecitation(int id) async {
    final isar = await db;
    return await isar.recitationEntitys.get(id);
  }

  Future<List<RecitationEntity>> getAllRecitations() async {
    final isar = await db;
    return await isar.recitationEntitys.where().findAll();
  }

  Future<void> updateRecitation(RecitationEntity type) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.recitationEntitys.put(type);
    });
  }

  Future<void> insertAllRecitations(List<RecitationEntity> types) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.recitationEntitys.putAll(types);
    });
  }

  Future<void> deleteRecitation(int id) async {
    final isar = await db;

    await isar.writeTxn(() async {
      await isar.recitationEntitys.delete(id);
    });
  }

  Future<void> deleteAllRecitations(List<int> ids) async {
    final isar = await db;

    await isar.writeTxn(() async {
      isar.recitationEntitys.deleteAll(ids);
    });
  }

  Future<void> closeDb() async {
    final isar = await db;
    await isar.close();
  }
}
