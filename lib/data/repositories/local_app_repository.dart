import '../../models/app_state_snapshot.dart';
import '../../models/daily_stat.dart';
import '../../models/focus_session.dart';
import '../../models/study_task.dart';
import '../local/daos/app_meta_dao.dart';
import '../local/daos/focus_dao.dart';
import '../local/daos/stats_dao.dart';
import '../local/daos/task_dao.dart';
import '../local/database/app_database.dart';

class LocalAppRepository {
  LocalAppRepository(this._database)
    : metaDao = AppMetaDao(_database),
      taskDao = TaskDao(_database),
      focusDao = FocusDao(_database),
      statsDao = StatsDao(_database);

  final AppDatabase _database;
  final AppMetaDao metaDao;
  final TaskDao taskDao;
  final FocusDao focusDao;
  final StatsDao statsDao;

  Future<AppStateSnapshot?> loadSnapshot() async {
    final meta = await metaDao.getAll();
    final tasks = await taskDao.getAll();
    final focusSessions = await focusDao.getAll();
    final dailyStats = await statsDao.getAll();

    if (meta.isEmpty &&
        tasks.isEmpty &&
        focusSessions.isEmpty &&
        dailyStats.isEmpty) {
      return null;
    }

    return AppStateSnapshot(
      lastActiveDateKey: meta[AppMetaDao.lastActiveDateKey] ?? '',
      selfDisciplineScore:
          int.tryParse(meta[AppMetaDao.selfDisciplineScore] ?? '') ?? 60,
      focusGoalMinutes:
          int.tryParse(meta[AppMetaDao.focusGoalMinutes] ?? '') ?? 60,
      themeModeName: meta[AppMetaDao.themeModeName] ?? 'system',
      tasks: tasks,
      focusSessions: focusSessions,
      dailyStats: dailyStats,
    );
  }

  Future<void> saveMeta({
    required String lastActiveDateKey,
    required int selfDisciplineScore,
    required int focusGoalMinutes,
    required String themeModeName,
  }) {
    return metaDao.saveAll({
      AppMetaDao.lastActiveDateKey: lastActiveDateKey,
      AppMetaDao.selfDisciplineScore: '$selfDisciplineScore',
      AppMetaDao.focusGoalMinutes: '$focusGoalMinutes',
      AppMetaDao.themeModeName: themeModeName,
    });
  }

  Future<void> saveSnapshot(AppStateSnapshot snapshot) async {
    await _database.transaction(() async {
      await saveMeta(
        lastActiveDateKey: snapshot.lastActiveDateKey,
        selfDisciplineScore: snapshot.selfDisciplineScore,
        focusGoalMinutes: snapshot.focusGoalMinutes,
        themeModeName: snapshot.themeModeName,
      );
      await taskDao.replaceAll(snapshot.tasks);
      await focusDao.replaceAll(snapshot.focusSessions);
      await statsDao.replaceAll(snapshot.dailyStats);
    });
  }

  Future<void> saveTask(StudyTask task) => taskDao.upsert(task);

  Future<void> replaceTasks(List<StudyTask> tasks) => taskDao.replaceAll(tasks);

  Future<void> deleteTask(String taskId) => taskDao.deleteById(taskId);

  Future<void> addFocusSession(FocusSession session) =>
      focusDao.insert(session);

  Future<void> replaceFocusSessions(List<FocusSession> sessions) {
    return focusDao.replaceAll(sessions);
  }

  Future<void> replaceDailyStats(List<DailyStat> stats) {
    return statsDao.replaceAll(stats);
  }

  Future<void> clear() async {
    await _database.transaction(() async {
      await metaDao.clear();
      await taskDao.clear();
      await focusDao.clear();
      await statsDao.clear();
    });
  }

  Future<void> close() => _database.close();
}
