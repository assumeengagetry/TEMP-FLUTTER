import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../models/app_state_snapshot.dart';
import '../../models/daily_stat.dart';
import '../../models/focus_session.dart';
import '../../models/study_task.dart';
import 'database/app_database.dart';
import '../repositories/local_app_repository.dart';

abstract class AppStorage {
  Future<AppStateSnapshot?> load();

  Future<void> save(AppStateSnapshot snapshot);

  Future<void> saveMeta({
    required String lastActiveDateKey,
    required int selfDisciplineScore,
    required int focusGoalMinutes,
    required String themeModeName,
  });

  Future<void> saveTask(StudyTask task);

  Future<void> replaceTasks(List<StudyTask> tasks);

  Future<void> deleteTask(String taskId);

  Future<void> addFocusSession(FocusSession session);

  Future<void> replaceFocusSessions(List<FocusSession> sessions);

  Future<void> replaceDailyStats(List<DailyStat> stats);

  Future<void> clear();

  Future<void> close();

  factory AppStorage.local() = DriftAppStorage.local;

  factory AppStorage.memory() = DriftAppStorage.memory;
}

class DriftAppStorage implements AppStorage {
  DriftAppStorage.local() : _repository = LocalAppRepository(AppDatabase());

  DriftAppStorage.memory()
    : _repository = LocalAppRepository(AppDatabase.inMemory());

  static const String _legacyStorageKey = 'college_study_supervisor_v2';

  final LocalAppRepository _repository;

  @override
  Future<AppStateSnapshot?> load() async {
    final existing = await _repository.loadSnapshot();
    if (existing != null) {
      return existing;
    }

    final migrated = await _loadLegacySnapshot();
    if (migrated != null) {
      await _repository.saveSnapshot(migrated);
      return migrated;
    }

    return null;
  }

  @override
  Future<void> save(AppStateSnapshot snapshot) {
    return _repository.saveSnapshot(snapshot);
  }

  @override
  Future<void> saveMeta({
    required String lastActiveDateKey,
    required int selfDisciplineScore,
    required int focusGoalMinutes,
    required String themeModeName,
  }) {
    return _repository.saveMeta(
      lastActiveDateKey: lastActiveDateKey,
      selfDisciplineScore: selfDisciplineScore,
      focusGoalMinutes: focusGoalMinutes,
      themeModeName: themeModeName,
    );
  }

  @override
  Future<void> saveTask(StudyTask task) {
    return _repository.saveTask(task);
  }

  @override
  Future<void> replaceTasks(List<StudyTask> tasks) {
    return _repository.replaceTasks(tasks);
  }

  @override
  Future<void> deleteTask(String taskId) {
    return _repository.deleteTask(taskId);
  }

  @override
  Future<void> addFocusSession(FocusSession session) {
    return _repository.addFocusSession(session);
  }

  @override
  Future<void> replaceFocusSessions(List<FocusSession> sessions) {
    return _repository.replaceFocusSessions(sessions);
  }

  @override
  Future<void> replaceDailyStats(List<DailyStat> stats) {
    return _repository.replaceDailyStats(stats);
  }

  @override
  Future<void> clear() async {
    await _repository.clear();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_legacyStorageKey);
  }

  @override
  Future<void> close() {
    return _repository.close();
  }

  Future<AppStateSnapshot?> _loadLegacySnapshot() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_legacyStorageKey);
    if (raw == null || raw.trim().isEmpty) {
      return null;
    }

    try {
      final snapshot = AppStateSnapshot.fromJson(
        jsonDecode(raw) as Map<String, dynamic>,
      );
      await prefs.remove(_legacyStorageKey);
      return snapshot;
    } catch (_) {
      return null;
    }
  }
}
