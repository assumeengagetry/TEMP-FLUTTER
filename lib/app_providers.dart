import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_controller.dart';
import 'features/ai_plan/ai_plan_controller.dart';
import 'features/focus/focus_controller.dart';
import 'features/settings/settings_controller.dart';
import 'features/stats/stats_controller.dart';
import 'features/tasks/task_controller.dart';

final studyAppControllerProvider =
    AsyncNotifierProvider<StudyAppNotifier, StudyAppState>(
      StudyAppNotifier.new,
    );

final studyAppStateProvider = Provider<StudyAppState>((ref) {
  return ref.watch(studyAppControllerProvider).requireValue;
});

final taskControllerProvider = Provider<TaskController>((ref) {
  return TaskController(
    state: ref.watch(studyAppStateProvider),
    actions: ref.read(studyAppControllerProvider.notifier),
  );
});

final focusControllerProvider = Provider<FocusController>((ref) {
  return FocusController(
    state: ref.watch(studyAppStateProvider),
    actions: ref.read(studyAppControllerProvider.notifier),
  );
});

final statsControllerProvider = Provider<StatsController>((ref) {
  return StatsController(state: ref.watch(studyAppStateProvider));
});

final aiPlanControllerProvider = Provider<AiPlanController>((ref) {
  return AiPlanController(state: ref.watch(studyAppStateProvider));
});

final settingsControllerProvider = Provider<SettingsController>((ref) {
  return SettingsController(
    state: ref.watch(studyAppStateProvider),
    actions: ref.read(studyAppControllerProvider.notifier),
  );
});
