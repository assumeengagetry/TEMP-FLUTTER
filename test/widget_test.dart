import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fun_lab/app_storage_factory.dart';
import 'package:fun_lab/data/local/app_storage.dart';
import 'package:fun_lab/models/daily_stat.dart';
import 'package:fun_lab/models/focus_session.dart';
import 'package:fun_lab/models/app_state_snapshot.dart';
import 'package:fun_lab/models/study_task.dart';
import 'package:fun_lab/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('大学生学习监督 App 可以正常启动', (WidgetTester tester) async {
    await tester.pumpWidget(StudySupervisorApp(storage: _TestStorageFactory()));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.text('监督台'), findsWidgets);
    expect(find.text('专注'), findsOneWidget);
    expect(find.text('统计'), findsOneWidget);
    expect(find.text('AI 计划'), findsOneWidget);
    expect(find.text('设置'), findsOneWidget);
  });

  testWidgets('切换到统计页时不会崩溃', (WidgetTester tester) async {
    await tester.pumpWidget(StudySupervisorApp(storage: _TestStorageFactory()));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    await tester.tap(find.text('统计').last);
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('统计'), findsWidgets);
    expect(find.textContaining('最近 7 天累计专注'), findsOneWidget);
  });
}

class _TestStorageFactory extends AppStorageFactory {
  @override
  AppStorage create() => _FakeStorage();
}

class _FakeStorage implements AppStorage {
  AppStateSnapshot? _snapshot;

  @override
  Future<void> addFocusSession(FocusSession session) async {
    final current = _snapshot;
    if (current == null) return;
    _snapshot = AppStateSnapshot(
      lastActiveDateKey: current.lastActiveDateKey,
      selfDisciplineScore: current.selfDisciplineScore,
      focusGoalMinutes: current.focusGoalMinutes,
      themeModeName: current.themeModeName,
      tasks: current.tasks,
      focusSessions: [session, ...current.focusSessions],
      dailyStats: current.dailyStats,
    );
  }

  @override
  Future<void> clear() async {
    _snapshot = null;
  }

  @override
  Future<void> close() async {}

  @override
  Future<void> deleteTask(String taskId) async {
    final current = _snapshot;
    if (current == null) return;
    _snapshot = AppStateSnapshot(
      lastActiveDateKey: current.lastActiveDateKey,
      selfDisciplineScore: current.selfDisciplineScore,
      focusGoalMinutes: current.focusGoalMinutes,
      themeModeName: current.themeModeName,
      tasks: current.tasks.where((item) => item.id != taskId).toList(),
      focusSessions: current.focusSessions,
      dailyStats: current.dailyStats,
    );
  }

  @override
  Future<AppStateSnapshot?> load() async {
    return _snapshot;
  }

  @override
  Future<void> replaceDailyStats(List<DailyStat> stats) async {
    final current = _snapshot;
    if (current == null) return;
    _snapshot = AppStateSnapshot(
      lastActiveDateKey: current.lastActiveDateKey,
      selfDisciplineScore: current.selfDisciplineScore,
      focusGoalMinutes: current.focusGoalMinutes,
      themeModeName: current.themeModeName,
      tasks: current.tasks,
      focusSessions: current.focusSessions,
      dailyStats: stats,
    );
  }

  @override
  Future<void> replaceFocusSessions(List<FocusSession> sessions) async {
    final current = _snapshot;
    if (current == null) return;
    _snapshot = AppStateSnapshot(
      lastActiveDateKey: current.lastActiveDateKey,
      selfDisciplineScore: current.selfDisciplineScore,
      focusGoalMinutes: current.focusGoalMinutes,
      themeModeName: current.themeModeName,
      tasks: current.tasks,
      focusSessions: sessions,
      dailyStats: current.dailyStats,
    );
  }

  @override
  Future<void> replaceTasks(List<StudyTask> tasks) async {
    final current = _snapshot;
    if (current == null) return;
    _snapshot = AppStateSnapshot(
      lastActiveDateKey: current.lastActiveDateKey,
      selfDisciplineScore: current.selfDisciplineScore,
      focusGoalMinutes: current.focusGoalMinutes,
      themeModeName: current.themeModeName,
      tasks: tasks,
      focusSessions: current.focusSessions,
      dailyStats: current.dailyStats,
    );
  }

  @override
  Future<void> save(AppStateSnapshot snapshot) async {
    _snapshot = snapshot;
  }

  @override
  Future<void> saveMeta({
    required String lastActiveDateKey,
    required int selfDisciplineScore,
    required int focusGoalMinutes,
    required String themeModeName,
  }) async {
    final current = _snapshot;
    _snapshot = AppStateSnapshot(
      lastActiveDateKey: lastActiveDateKey,
      selfDisciplineScore: selfDisciplineScore,
      focusGoalMinutes: focusGoalMinutes,
      themeModeName: themeModeName,
      tasks: current?.tasks ?? const [],
      focusSessions: current?.focusSessions ?? const [],
      dailyStats: current?.dailyStats ?? const [],
    );
  }

  @override
  Future<void> saveTask(StudyTask task) async {
    final current = _snapshot;
    if (current == null) return;
    final tasks = [
      for (final item in current.tasks)
        if (item.id == task.id) task else item,
    ];
    if (!tasks.any((item) => item.id == task.id)) {
      tasks.add(task);
    }
    _snapshot = AppStateSnapshot(
      lastActiveDateKey: current.lastActiveDateKey,
      selfDisciplineScore: current.selfDisciplineScore,
      focusGoalMinutes: current.focusGoalMinutes,
      themeModeName: current.themeModeName,
      tasks: tasks,
      focusSessions: current.focusSessions,
      dailyStats: current.dailyStats,
    );
  }
}
