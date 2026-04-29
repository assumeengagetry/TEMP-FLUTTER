import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_dependencies.dart';
import 'core/utils/date_utils.dart';
import 'data/local/app_storage.dart';
import 'models/ai_plan.dart';
import 'models/app_state_snapshot.dart';
import 'models/daily_stat.dart';
import 'models/focus_session.dart';
import 'models/study_task.dart';

class StudyAppState {
  const StudyAppState({
    required this.lastActiveDateKey,
    required this.themeMode,
    required this.focusGoalMinutes,
    required this.selfDisciplineScore,
    required this.tasks,
    required this.focusSessions,
    required this.dailyStats,
  });

  factory StudyAppState.fromSnapshot(
    AppStateSnapshot snapshot, {
    required String fallbackDateKey,
  }) {
    return StudyAppState(
      lastActiveDateKey: snapshot.lastActiveDateKey.isEmpty
          ? fallbackDateKey
          : snapshot.lastActiveDateKey,
      themeMode: snapshot.themeMode,
      focusGoalMinutes: snapshot.focusGoalMinutes,
      selfDisciplineScore: snapshot.selfDisciplineScore,
      tasks: List.unmodifiable(snapshot.tasks),
      focusSessions: List.unmodifiable(snapshot.focusSessions),
      dailyStats: List.unmodifiable(snapshot.dailyStats),
    );
  }

  final String lastActiveDateKey;
  final ThemeMode themeMode;
  final int focusGoalMinutes;
  final int selfDisciplineScore;
  final List<StudyTask> tasks;
  final List<FocusSession> focusSessions;
  final List<DailyStat> dailyStats;

  StudyAppState copyWith({
    String? lastActiveDateKey,
    ThemeMode? themeMode,
    int? focusGoalMinutes,
    int? selfDisciplineScore,
    List<StudyTask>? tasks,
    List<FocusSession>? focusSessions,
    List<DailyStat>? dailyStats,
  }) {
    return StudyAppState(
      lastActiveDateKey: lastActiveDateKey ?? this.lastActiveDateKey,
      themeMode: themeMode ?? this.themeMode,
      focusGoalMinutes: focusGoalMinutes ?? this.focusGoalMinutes,
      selfDisciplineScore: selfDisciplineScore ?? this.selfDisciplineScore,
      tasks: List.unmodifiable(tasks ?? this.tasks),
      focusSessions: List.unmodifiable(focusSessions ?? this.focusSessions),
      dailyStats: List.unmodifiable(dailyStats ?? this.dailyStats),
    );
  }

  AppStateSnapshot toSnapshot() {
    return AppStateSnapshot(
      lastActiveDateKey: lastActiveDateKey,
      selfDisciplineScore: selfDisciplineScore,
      focusGoalMinutes: focusGoalMinutes,
      themeModeName: themeMode.name,
      tasks: tasks,
      focusSessions: focusSessions,
      dailyStats: dailyStats,
    );
  }

  List<String> get courses {
    final names = <String>{};
    for (final task in tasks) {
      names.add(task.course);
    }
    for (final session in focusSessions) {
      names.add(session.course);
    }
    final result = names.where((item) => item.trim().isNotEmpty).toList()
      ..sort();
    return result.isEmpty ? ['通用自习'] : result;
  }

  List<StudyTask> get openTasks => tasks.where((item) => !item.done).toList();

  int get totalFocusMinutes {
    return focusSessions.fold(0, (sum, item) => sum + item.actualMinutes);
  }

  int get doneCount => tasks.where((item) => item.done).length;
  int get totalCount => tasks.length;

  double get taskProgress => tasks.isEmpty ? 0 : doneCount / tasks.length;

  String get disciplineLabel {
    if (selfDisciplineScore <= 40) return '摸鱼危险';
    if (selfDisciplineScore <= 70) return '状态一般';
    if (selfDisciplineScore <= 85) return '状态良好';
    return '自律优秀';
  }

  int todayFocusMinutesAt(DateTime now) {
    final todayKey = AppDateUtils.dateKey(AppDateUtils.startOfDay(now));
    return focusSessions
        .where((item) => AppDateUtils.dateKey(item.startedAt) == todayKey)
        .fold(0, (sum, item) => sum + item.actualMinutes);
  }

  int overdueTaskCountAt(DateTime now) {
    return tasks.where((item) => item.isOverdueAt(now)).length;
  }

  int currentStreakAt(DateTime now) {
    final today = AppDateUtils.startOfDay(now);
    var streak = 0;
    for (var index = 0; index < 365; index++) {
      final date = today.subtract(Duration(days: index));
      final key = AppDateUtils.dateKey(date);
      final stat = dailyStatForKey(key, now: now);
      if (!stat.success) {
        break;
      }
      streak++;
    }
    return streak;
  }

  int todayCompletedPomodorosAt(DateTime now) {
    final todayKey = AppDateUtils.dateKey(AppDateUtils.startOfDay(now));
    return focusSessions.where((item) {
      return AppDateUtils.dateKey(item.startedAt) == todayKey &&
          item.completed &&
          item.mode == FocusMode.preset;
    }).length;
  }

  bool deepFocusUnlockedAt(DateTime now) {
    return todayCompletedPomodorosAt(now) >= 2;
  }

  List<DailyStat> recentSevenStatsAt(DateTime now) {
    final today = AppDateUtils.startOfDay(now);
    final stats = <DailyStat>[];
    for (var index = 6; index >= 0; index--) {
      final date = today.subtract(Duration(days: index));
      final key = AppDateUtils.dateKey(date);
      stats.add(dailyStatForKey(key, now: now));
    }
    return stats;
  }

  Map<String, int> focusMinutesByCourse({
    required DateTime now,
    int days = 30,
  }) {
    final from = AppDateUtils.startOfDay(
      now,
    ).subtract(Duration(days: days - 1));
    final result = <String, int>{};
    for (final item in focusSessions) {
      if (item.startedAt.isBefore(from)) continue;
      result.update(
        item.course,
        (value) => value + item.actualMinutes,
        ifAbsent: () => item.actualMinutes,
      );
    }
    final entries = result.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return {for (final item in entries) item.key: item.value};
  }

  AiPlanSuggestion generateAiPlan({
    required int availableMinutes,
    required DateTime now,
  }) {
    final sortedTasks = [...openTasks]
      ..sort((a, b) {
        final priorityCompare = b.priority.index.compareTo(a.priority.index);
        if (priorityCompare != 0) return priorityCompare;
        if (a.deadline == null && b.deadline == null) return 0;
        if (a.deadline == null) return 1;
        if (b.deadline == null) return -1;
        return a.deadline!.compareTo(b.deadline!);
      });

    var remain = availableMinutes;
    final blocks = <AiPlanBlock>[];
    var startMinute = 19 * 60;
    for (final task in sortedTasks.take(4)) {
      if (remain <= 0) break;
      final maxBlockMinutes = remain > 45 ? 45 : remain;
      if (maxBlockMinutes < 15) {
        break;
      }
      final blockMinutes = task.estimatedMinutes.clamp(15, maxBlockMinutes);
      final endMinute = startMinute + blockMinutes;
      blocks.add(
        AiPlanBlock(
          timeLabel: '${_formatClock(startMinute)}-${_formatClock(endMinute)}',
          taskLabel: task.title,
          modeLabel: blockMinutes >= 40 ? 'deep_focus' : task.type.label,
        ),
      );
      startMinute = endMinute + 10;
      remain -= blockMinutes + 10;
    }

    final overdue = overdueTaskCountAt(now);
    final recentStats = recentSevenStatsAt(now);
    final weakDayCount = recentStats
        .where((item) => item.focusMinutes == 0)
        .length;
    final focusSum = recentStats.fold(
      0,
      (sum, item) => sum + item.focusMinutes,
    );
    final summary = sortedTasks.isEmpty
        ? '今日未发现待处理任务，建议优先做一次 25 分钟复盘并整理明日计划。'
        : '建议先处理 ${sortedTasks.first.course} 的高优先级任务，再用短时专注清理零散任务。';
    final risk = overdue > 0
        ? '当前有 $overdue 个逾期任务，优先补交或拆分成 25 分钟小块处理。'
        : weakDayCount > 1
        ? '最近 7 天有 $weakDayCount 天完全未专注，建议启用 60 分钟保底目标避免断签。'
        : '最近一周累计专注 $focusSum 分钟，节奏稳定，可以尝试连续两轮深度专注。';

    return AiPlanSuggestion(
      summary: summary,
      risk: risk,
      blocks: blocks,
      weeklyReview: weeklyReviewAt(now),
    );
  }

  String weeklyReviewAt(DateTime now) {
    final stats = recentSevenStatsAt(now);
    final focusSum = stats.fold(0, (sum, item) => sum + item.focusMinutes);
    final bestDay = [...stats]
      ..sort((a, b) => b.focusMinutes.compareTo(a.focusMinutes));
    final successDays = stats.where((item) => item.success).length;
    return '最近 7 天累计专注 $focusSum 分钟，成功打卡 $successDays 天。'
        '最佳状态出现在 ${bestDay.first.dateKey}，当日专注 ${bestDay.first.focusMinutes} 分钟。';
  }

  List<StudyTask> tasksForCourse(String? course) {
    if (course == null || course == '全部') return [...tasks];
    return tasks.where((item) => item.course == course).toList();
  }

  DailyStat dailyStatForKey(String key, {required DateTime now}) {
    final todayKey = AppDateUtils.dateKey(AppDateUtils.startOfDay(now));
    if (key == todayKey) {
      return DailyStat(
        dateKey: key,
        completedTasks: tasks
            .where(
              (item) =>
                  item.completedAt != null &&
                  AppDateUtils.dateKey(item.completedAt!) == key,
            )
            .length,
        totalTasks: tasks.length,
        focusMinutes: todayFocusMinutesAt(now),
        disciplineScore: selfDisciplineScore,
        success:
            todayFocusMinutesAt(now) >= focusGoalMinutes &&
            overdueTaskCountAt(now) == 0,
      );
    }
    return dailyStats.firstWhere(
      (item) => item.dateKey == key,
      orElse: () => _emptyDailyStat(key),
    );
  }
}

class StudyAppNotifier extends AsyncNotifier<StudyAppState> {
  late final AppStorage _storage;

  DateTime get _today => AppDateUtils.startOfDay(DateTime.now());
  String get _todayKey => AppDateUtils.dateKey(_today);

  @override
  FutureOr<StudyAppState> build() async {
    _storage = ref.watch(appStorageProvider);

    final snapshot = await _storage.load();
    if (snapshot == null) {
      final seeded = _touch(
        StudyAppState(
          lastActiveDateKey: _todayKey,
          themeMode: ThemeMode.system,
          focusGoalMinutes: 60,
          selfDisciplineScore: 60,
          tasks: _seedTasks(),
          focusSessions: const [],
          dailyStats: const [],
        ),
      );
      await _saveAll(seeded);
      return seeded;
    }

    var current = StudyAppState.fromSnapshot(
      snapshot,
      fallbackDateKey: _todayKey,
    );
    current = _rolloverIfNeeded(current);
    current = _touch(current);
    await _saveAll(current);
    return current;
  }

  Future<void> cycleThemeMode() async {
    final current = _current;
    final next = _touch(
      current.copyWith(
        themeMode: switch (current.themeMode) {
          ThemeMode.system => ThemeMode.light,
          ThemeMode.light => ThemeMode.dark,
          ThemeMode.dark => ThemeMode.system,
        },
      ),
    );
    await _commit(next, () => _saveMeta(next));
  }

  Future<void> setFocusGoal(int minutes) async {
    final next = _touch(_current.copyWith(focusGoalMinutes: minutes));
    await _commit(next, () => _saveMeta(next));
  }

  Future<void> addTask(StudyTask task) async {
    final next = _touch(_current.copyWith(tasks: [..._current.tasks, task]));
    await _commit(next, () async {
      await _storage.saveTask(task);
      await _saveMeta(next);
    });
  }

  Future<void> updateTask(StudyTask task) async {
    final next = _touch(
      _current.copyWith(
        tasks: [
          for (final item in _current.tasks)
            if (item.id == task.id) task else item,
        ],
      ),
    );
    await _commit(next, () async {
      await _storage.saveTask(task);
      await _saveMeta(next);
    });
  }

  Future<void> deleteTask(String taskId) async {
    final next = _touch(
      _current.copyWith(
        tasks: _current.tasks.where((item) => item.id != taskId).toList(),
      ),
    );
    await _commit(next, () async {
      await _storage.deleteTask(taskId);
      await _saveMeta(next);
    });
  }

  Future<void> toggleTaskDone(String taskId, bool done) async {
    final now = DateTime.now();
    final updatedTasks = [
      for (final item in _current.tasks)
        if (item.id == taskId)
          item.copyWith(
            done: done,
            completedAt: done ? now : null,
            clearCompletedAt: !done,
          )
        else
          item,
    ];
    final task = updatedTasks.firstWhere((item) => item.id == taskId);
    final next = _touch(
      _current.copyWith(
        tasks: updatedTasks,
        selfDisciplineScore: _clampScore(
          _current.selfDisciplineScore + (done ? task.points : -task.points),
        ),
      ),
    );

    await _commit(next, () async {
      await _storage.saveTask(task);
      await _saveMeta(next);
    });
  }

  Future<void> addFocusSession(FocusSession session) async {
    final now = DateTime.now();
    final sessions = [session, ..._current.focusSessions]
      ..sort((a, b) => b.startedAt.compareTo(a.startedAt));

    var reward = session.completed ? session.actualMinutes ~/ 5 : 0;
    reward = reward.clamp(0, 20);
    if (session.completed) {
      reward = reward < 5 ? 5 : reward;
    }
    final preview = _current.copyWith(focusSessions: sessions);
    if (preview.deepFocusUnlockedAt(now) && session.completed) {
      reward += 5;
    }
    if (session.interrupted) {
      reward = -5;
    }

    final next = _touch(
      preview.copyWith(
        selfDisciplineScore: _clampScore(_current.selfDisciplineScore + reward),
      ),
    );

    await _commit(next, () async {
      await _storage.addFocusSession(session);
      await _saveMeta(next);
    });
  }

  Future<void> resetToday() async {
    final todayStart = _today;
    final todayKey = _todayKey;
    final next = _touch(
      _current.copyWith(
        focusSessions: _current.focusSessions
            .where((item) => item.startedAt.isBefore(todayStart))
            .toList(),
        tasks: [
          for (final item in _current.tasks)
            if (item.completedAt != null &&
                AppDateUtils.dateKey(item.completedAt!) == todayKey)
              item.copyWith(done: false, clearCompletedAt: true)
            else
              item,
        ],
        selfDisciplineScore: _clampScore(_current.selfDisciplineScore - 10),
      ),
    );

    await _commit(next, () async {
      await _storage.replaceFocusSessions(next.focusSessions);
      await _storage.replaceTasks(next.tasks);
      await _saveMeta(next);
    });
  }

  Future<void> clearAllData() async {
    final next = _touch(
      StudyAppState(
        lastActiveDateKey: _todayKey,
        themeMode: ThemeMode.system,
        focusGoalMinutes: 60,
        selfDisciplineScore: 60,
        tasks: _seedTasks(),
        focusSessions: const [],
        dailyStats: const [],
      ),
    );

    await _commit(next, () async {
      await _storage.clear();
      await _saveAll(next);
    });
  }

  StudyAppState get _current => state.requireValue;

  Future<void> _commit(
    StudyAppState next,
    Future<void> Function() persist,
  ) async {
    final previous = _current;
    state = AsyncValue.data(next);
    try {
      await persist();
    } catch (error, stackTrace) {
      state = AsyncValue.data(previous);
      Error.throwWithStackTrace(error, stackTrace);
    }
  }

  StudyAppState _rolloverIfNeeded(StudyAppState current) {
    if (current.lastActiveDateKey.isEmpty ||
        current.lastActiveDateKey == _todayKey) {
      return current.copyWith(lastActiveDateKey: _todayKey);
    }

    var updated = current;
    var cursor =
        DateTime.tryParse('${current.lastActiveDateKey} 00:00:00') ?? _today;
    while (cursor.isBefore(_today)) {
      updated = _finalizeDay(
        updated,
        dateKey: AppDateUtils.dateKey(cursor),
        day: cursor,
      );
      cursor = cursor.add(const Duration(days: 1));
    }
    return updated.copyWith(lastActiveDateKey: _todayKey);
  }

  StudyAppState _finalizeDay(
    StudyAppState current, {
    required String dateKey,
    required DateTime day,
  }) {
    final alreadyExists = current.dailyStats.any(
      (item) => item.dateKey == dateKey,
    );
    if (alreadyExists) {
      return current;
    }

    final focusMinutes = current.focusSessions
        .where((item) => AppDateUtils.dateKey(item.startedAt) == dateKey)
        .fold(0, (sum, item) => sum + item.actualMinutes);
    final completedTasks = current.tasks
        .where(
          (item) =>
              item.completedAt != null &&
              AppDateUtils.dateKey(item.completedAt!) == dateKey,
        )
        .length;
    final totalTasks = current.tasks
        .where((item) => !item.createdAt.isAfter(AppDateUtils.endOfDay(day)))
        .length;
    final success =
        focusMinutes >= current.focusGoalMinutes && completedTasks > 0;

    var score = current.selfDisciplineScore;
    if (success) {
      score = _clampScore(score + 10);
    } else {
      score = _clampScore(score - 15);
    }

    final penalty = _applyOverduePenalty(current.tasks, score, day);
    final stats = [
      ...current.dailyStats.where((item) => item.dateKey != dateKey),
      DailyStat(
        dateKey: dateKey,
        completedTasks: completedTasks,
        totalTasks: totalTasks,
        focusMinutes: focusMinutes,
        disciplineScore: penalty.score,
        success: success,
      ),
    ]..sort((a, b) => a.dateKey.compareTo(b.dateKey));

    return current.copyWith(
      tasks: penalty.tasks,
      dailyStats: stats,
      selfDisciplineScore: penalty.score,
    );
  }

  _PenaltyResult _applyOverduePenalty(
    List<StudyTask> tasks,
    int score,
    DateTime day,
  ) {
    final dayEnd = AppDateUtils.endOfDay(day);
    var penaltyCount = 0;
    final updated = <StudyTask>[];
    for (final item in tasks) {
      final shouldApply =
          !item.done &&
          !item.overduePenaltyApplied &&
          item.deadline != null &&
          item.deadline!.isBefore(dayEnd);
      if (shouldApply) {
        penaltyCount++;
        updated.add(item.copyWith(overduePenaltyApplied: true));
      } else {
        updated.add(item);
      }
    }

    final nextScore = penaltyCount == 0
        ? score
        : _clampScore(score - penaltyCount * 10);
    return _PenaltyResult(List.unmodifiable(updated), nextScore);
  }

  StudyAppState _touch(StudyAppState state) {
    return state.copyWith(lastActiveDateKey: _todayKey);
  }

  Future<void> _saveAll(StudyAppState state) {
    return _storage.save(state.toSnapshot());
  }

  Future<void> _saveMeta(StudyAppState state) {
    return _storage.saveMeta(
      lastActiveDateKey: state.lastActiveDateKey,
      selfDisciplineScore: state.selfDisciplineScore,
      focusGoalMinutes: state.focusGoalMinutes,
      themeModeName: state.themeMode.name,
    );
  }

  int _clampScore(int value) => value.clamp(0, 100);

  List<StudyTask> _seedTasks() {
    final now = DateTime.now();
    return [
      StudyTask(
        id: 'os-1',
        title: '复习 CPU 调度算法并整理甘特图',
        course: '操作系统',
        type: StudyTaskType.review,
        priority: StudyTaskPriority.high,
        points: 15,
        estimatedMinutes: 45,
        createdAt: now,
        deadline: now.add(const Duration(days: 1)),
      ),
      StudyTask(
        id: 'net-1',
        title: '完成 VLAN 实验报告截图说明',
        course: '计算机网络',
        type: StudyTaskType.lab,
        priority: StudyTaskPriority.urgent,
        points: 20,
        estimatedMinutes: 60,
        createdAt: now,
        deadline: now.add(const Duration(days: 2)),
      ),
      StudyTask(
        id: 'se-1',
        title: '补充 ERP 需求分析报告',
        course: '软件工程',
        type: StudyTaskType.assignment,
        priority: StudyTaskPriority.medium,
        points: 10,
        estimatedMinutes: 30,
        createdAt: now,
      ),
      StudyTask(
        id: 'flutter-1',
        title: '完成 Flutter 页面重构和组件拆分',
        course: 'Flutter',
        type: StudyTaskType.coding,
        priority: StudyTaskPriority.high,
        points: 15,
        estimatedMinutes: 45,
        createdAt: now,
        note: '优先提炼主题、模型和统计页面。',
      ),
    ];
  }
}

class _PenaltyResult {
  const _PenaltyResult(this.tasks, this.score);

  final List<StudyTask> tasks;
  final int score;
}

DailyStat _emptyDailyStat(String key) {
  return DailyStat(
    dateKey: key,
    completedTasks: 0,
    totalTasks: 0,
    focusMinutes: 0,
    disciplineScore: 60,
    success: false,
  );
}

String _formatClock(int totalMinutes) {
  final hour = (totalMinutes ~/ 60).toString().padLeft(2, '0');
  final minute = (totalMinutes % 60).toString().padLeft(2, '0');
  return '$hour:$minute';
}
