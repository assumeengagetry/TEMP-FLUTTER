import 'package:drift/drift.dart';

import '../database/app_database.dart';

class AppMetaDao {
  AppMetaDao(this._database);

  static const lastActiveDateKey = 'lastActiveDateKey';
  static const selfDisciplineScore = 'selfDisciplineScore';
  static const focusGoalMinutes = 'focusGoalMinutes';
  static const themeModeName = 'themeModeName';

  final AppDatabase _database;

  Future<Map<String, String>> getAll() async {
    final rows = await _database.select(_database.appMetaEntries).get();
    return {for (final row in rows) row.key: row.value};
  }

  Future<void> saveAll(Map<String, String> values) async {
    await _database.batch((batch) {
      for (final entry in values.entries) {
        batch.insert(
          _database.appMetaEntries,
          AppMetaEntriesCompanion.insert(key: entry.key, value: entry.value),
          onConflict: DoUpdate(
            (_) => AppMetaEntriesCompanion(value: Value(entry.value)),
          ),
        );
      }
    });
  }

  Future<void> clear() => _database.delete(_database.appMetaEntries).go();
}
