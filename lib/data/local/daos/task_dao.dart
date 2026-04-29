import 'package:drift/drift.dart';

import '../../../models/study_task.dart';
import '../database/app_database.dart';
import '../database/mappers.dart';

class TaskDao {
  TaskDao(this._database);

  final AppDatabase _database;

  Future<List<StudyTask>> getAll() async {
    final rows = await (_database.select(
      _database.tasks,
    )..orderBy([(table) => OrderingTerm.asc(table.createdAt)])).get();
    return rows.map(mapTaskRow).toList();
  }

  Future<void> upsert(StudyTask task) {
    return _database
        .into(_database.tasks)
        .insertOnConflictUpdate(taskToCompanion(task));
  }

  Future<void> replaceAll(List<StudyTask> tasks) async {
    await _database.transaction(() async {
      await _database.delete(_database.tasks).go();
      if (tasks.isEmpty) return;
      await _database.batch((batch) {
        batch.insertAll(_database.tasks, tasks.map(taskToCompanion).toList());
      });
    });
  }

  Future<void> deleteById(String taskId) {
    return (_database.delete(
      _database.tasks,
    )..where((table) => table.id.equals(taskId))).go();
  }

  Future<void> clear() => _database.delete(_database.tasks).go();
}
