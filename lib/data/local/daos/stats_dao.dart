import 'package:drift/drift.dart';

import '../../../models/daily_stat.dart';
import '../database/app_database.dart';
import '../database/mappers.dart';

class StatsDao {
  StatsDao(this._database);

  final AppDatabase _database;

  Future<List<DailyStat>> getAll() async {
    final rows = await (_database.select(
      _database.dailyStatRecords,
    )..orderBy([(table) => OrderingTerm.asc(table.dateKey)])).get();
    return rows.map(mapDailyStatRow).toList();
  }

  Future<void> upsert(DailyStat stat) {
    return _database
        .into(_database.dailyStatRecords)
        .insertOnConflictUpdate(dailyStatToCompanion(stat));
  }

  Future<void> replaceAll(List<DailyStat> stats) async {
    await _database.transaction(() async {
      await _database.delete(_database.dailyStatRecords).go();
      if (stats.isEmpty) return;
      await _database.batch((batch) {
        batch.insertAll(
          _database.dailyStatRecords,
          stats.map(dailyStatToCompanion).toList(),
        );
      });
    });
  }

  Future<void> clear() => _database.delete(_database.dailyStatRecords).go();
}
