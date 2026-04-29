import 'package:drift/drift.dart';

import '../../../models/focus_session.dart';
import '../database/app_database.dart';
import '../database/mappers.dart';

class FocusDao {
  FocusDao(this._database);

  final AppDatabase _database;

  Future<List<FocusSession>> getAll() async {
    final rows = await (_database.select(
      _database.focusSessionRecords,
    )..orderBy([(table) => OrderingTerm.desc(table.startedAt)])).get();
    return rows.map(mapFocusSessionRow).toList();
  }

  Future<void> insert(FocusSession session) {
    return _database
        .into(_database.focusSessionRecords)
        .insertOnConflictUpdate(focusSessionToCompanion(session));
  }

  Future<void> replaceAll(List<FocusSession> sessions) async {
    await _database.transaction(() async {
      await _database.delete(_database.focusSessionRecords).go();
      if (sessions.isEmpty) return;
      await _database.batch((batch) {
        batch.insertAll(
          _database.focusSessionRecords,
          sessions.map(focusSessionToCompanion).toList(),
        );
      });
    });
  }

  Future<void> clear() => _database.delete(_database.focusSessionRecords).go();
}
