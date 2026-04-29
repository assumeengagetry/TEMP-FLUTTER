import 'package:drift/drift.dart';

import '../../../../models/app_state_snapshot.dart';
import '../../../../models/daily_stat.dart' as daily_models;
import '../../../../models/focus_session.dart' as focus_models;
import '../../../../models/study_task.dart' as task_models;
import 'connection/shared.dart' as connection;

part 'app_database.g.dart';

class AppMetaEntries extends Table {
  TextColumn get key => text()();

  TextColumn get value => text()();

  @override
  Set<Column<Object>> get primaryKey => {key};
}

class Tasks extends Table {
  TextColumn get id => text()();

  TextColumn get title => text()();

  TextColumn get course => text()();

  TextColumn get type => text()();

  TextColumn get priority => text()();

  IntColumn get points => integer()();

  IntColumn get estimatedMinutes => integer()();

  DateTimeColumn get createdAt => dateTime()();

  DateTimeColumn get deadline => dateTime().nullable()();

  TextColumn get note => text().withDefault(const Constant(''))();

  TextColumn get proofText => text().withDefault(const Constant(''))();

  TextColumn get proofLink => text().withDefault(const Constant(''))();

  BoolColumn get done => boolean().withDefault(const Constant(false))();

  DateTimeColumn get completedAt => dateTime().nullable()();

  BoolColumn get overduePenaltyApplied =>
      boolean().withDefault(const Constant(false))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class FocusSessionRecords extends Table {
  TextColumn get id => text()();

  TextColumn get course => text()();

  TextColumn get mode => text()();

  IntColumn get plannedMinutes => integer()();

  IntColumn get actualMinutes => integer()();

  BoolColumn get completed => boolean()();

  BoolColumn get interrupted => boolean()();

  DateTimeColumn get startedAt => dateTime()();

  DateTimeColumn get endedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class DailyStatRecords extends Table {
  TextColumn get dateKey => text()();

  IntColumn get completedTasks => integer()();

  IntColumn get totalTasks => integer()();

  IntColumn get focusMinutes => integer()();

  IntColumn get disciplineScore => integer()();

  BoolColumn get success => boolean()();

  @override
  Set<Column<Object>> get primaryKey => {dateKey};
}

@DriftDatabase(
  tables: [AppMetaEntries, Tasks, FocusSessionRecords, DailyStatRecords],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
    : super(executor ?? connection.openStudyDatabase());

  AppDatabase.inMemory() : super(connection.openStudyDatabase(inMemory: true));

  static const _lastActiveDateKey = 'lastActiveDateKey';
  static const _selfDisciplineScore = 'selfDisciplineScore';
  static const _focusGoalMinutes = 'focusGoalMinutes';
  static const _themeModeName = 'themeModeName';

  @override
  int get schemaVersion => 1;

  Future<bool> hasAnyData() async {
    final metaCount = await _rowCount(appMetaEntries);
    final taskCount = await _rowCount(tasks);
    final focusCount = await _rowCount(focusSessionRecords);
    final statCount = await _rowCount(dailyStatRecords);
    return metaCount + taskCount + focusCount + statCount > 0;
  }

  Future<AppStateSnapshot?> readSnapshot() async {
    if (!await hasAnyData()) return null;

    final metaRows = await select(appMetaEntries).get();
    final meta = {for (final row in metaRows) row.key: row.value};
    final taskRows = await select(tasks).get();
    final focusRows = await select(focusSessionRecords).get();
    final statRows = await select(dailyStatRecords).get();

    return AppStateSnapshot(
      lastActiveDateKey: meta[_lastActiveDateKey] ?? '',
      selfDisciplineScore: int.tryParse(meta[_selfDisciplineScore] ?? '') ?? 60,
      focusGoalMinutes: int.tryParse(meta[_focusGoalMinutes] ?? '') ?? 60,
      themeModeName: meta[_themeModeName] ?? 'system',
      tasks: taskRows.map(_mapTaskRow).toList(),
      focusSessions: focusRows.map(_mapFocusRow).toList(),
      dailyStats: statRows.map(_mapDailyStatRow).toList(),
    );
  }

  Future<void> writeSnapshot(AppStateSnapshot snapshot) async {
    await transaction(() async {
      await delete(appMetaEntries).go();
      await delete(tasks).go();
      await delete(focusSessionRecords).go();
      await delete(dailyStatRecords).go();

      await batch((batch) {
        batch.insertAll(appMetaEntries, [
          AppMetaEntriesCompanion.insert(
            key: _lastActiveDateKey,
            value: snapshot.lastActiveDateKey,
          ),
          AppMetaEntriesCompanion.insert(
            key: _selfDisciplineScore,
            value: '${snapshot.selfDisciplineScore}',
          ),
          AppMetaEntriesCompanion.insert(
            key: _focusGoalMinutes,
            value: '${snapshot.focusGoalMinutes}',
          ),
          AppMetaEntriesCompanion.insert(
            key: _themeModeName,
            value: snapshot.themeModeName,
          ),
        ]);

        if (snapshot.tasks.isNotEmpty) {
          batch.insertAll(tasks, snapshot.tasks.map(_taskCompanion).toList());
        }

        if (snapshot.focusSessions.isNotEmpty) {
          batch.insertAll(
            focusSessionRecords,
            snapshot.focusSessions.map(_focusCompanion).toList(),
          );
        }

        if (snapshot.dailyStats.isNotEmpty) {
          batch.insertAll(
            dailyStatRecords,
            snapshot.dailyStats.map(_dailyStatCompanion).toList(),
          );
        }
      });
    });
  }

  Future<void> clearAllData() async {
    await transaction(() async {
      await delete(appMetaEntries).go();
      await delete(tasks).go();
      await delete(focusSessionRecords).go();
      await delete(dailyStatRecords).go();
    });
  }

  Future<int> _rowCount(TableInfo<Table, dynamic> table) async {
    final countExpression = table.$columns.first.count();
    final query = selectOnly(table)..addColumns([countExpression]);
    final row = await query.getSingle();
    return row.read(countExpression) ?? 0;
  }

  task_models.StudyTask _mapTaskRow(Task row) {
    return task_models.StudyTask(
      id: row.id,
      title: row.title,
      course: row.course,
      type: task_models.StudyTaskTypeX.fromName(row.type),
      priority: task_models.StudyTaskPriorityX.fromName(row.priority),
      points: row.points,
      estimatedMinutes: row.estimatedMinutes,
      createdAt: row.createdAt,
      deadline: row.deadline,
      note: row.note,
      proofText: row.proofText,
      proofLink: row.proofLink,
      done: row.done,
      completedAt: row.completedAt,
      overduePenaltyApplied: row.overduePenaltyApplied,
    );
  }

  focus_models.FocusSession _mapFocusRow(FocusSessionRecord row) {
    return focus_models.FocusSession(
      id: row.id,
      course: row.course,
      mode: focus_models.FocusMode.values.firstWhere(
        (item) => item.name == row.mode,
        orElse: () => focus_models.FocusMode.preset,
      ),
      plannedMinutes: row.plannedMinutes,
      actualMinutes: row.actualMinutes,
      completed: row.completed,
      interrupted: row.interrupted,
      startedAt: row.startedAt,
      endedAt: row.endedAt,
    );
  }

  daily_models.DailyStat _mapDailyStatRow(DailyStatRecord row) {
    return daily_models.DailyStat(
      dateKey: row.dateKey,
      completedTasks: row.completedTasks,
      totalTasks: row.totalTasks,
      focusMinutes: row.focusMinutes,
      disciplineScore: row.disciplineScore,
      success: row.success,
    );
  }

  TasksCompanion _taskCompanion(task_models.StudyTask task) {
    return TasksCompanion.insert(
      id: task.id,
      title: task.title,
      course: task.course,
      type: task.type.name,
      priority: task.priority.name,
      points: task.points,
      estimatedMinutes: task.estimatedMinutes,
      createdAt: task.createdAt,
      deadline: Value(task.deadline),
      note: Value(task.note),
      proofText: Value(task.proofText),
      proofLink: Value(task.proofLink),
      done: Value(task.done),
      completedAt: Value(task.completedAt),
      overduePenaltyApplied: Value(task.overduePenaltyApplied),
    );
  }

  FocusSessionRecordsCompanion _focusCompanion(
    focus_models.FocusSession session,
  ) {
    return FocusSessionRecordsCompanion.insert(
      id: session.id,
      course: session.course,
      mode: session.mode.name,
      plannedMinutes: session.plannedMinutes,
      actualMinutes: session.actualMinutes,
      completed: session.completed,
      interrupted: session.interrupted,
      startedAt: session.startedAt,
      endedAt: session.endedAt,
    );
  }

  DailyStatRecordsCompanion _dailyStatCompanion(daily_models.DailyStat stat) {
    return DailyStatRecordsCompanion.insert(
      dateKey: stat.dateKey,
      completedTasks: stat.completedTasks,
      totalTasks: stat.totalTasks,
      focusMinutes: stat.focusMinutes,
      disciplineScore: stat.disciplineScore,
      success: stat.success,
    );
  }
}
