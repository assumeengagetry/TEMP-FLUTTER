import '../../app_controller.dart';
import '../../models/focus_session.dart';

class FocusController {
  const FocusController({required this.state, required this.actions});

  final StudyAppState state;
  final StudyAppNotifier actions;

  List<String> get courses => state.courses;
  int get focusGoalMinutes => state.focusGoalMinutes;
  int get todayFocusMinutes => state.todayFocusMinutesAt(DateTime.now());
  int get totalFocusMinutes => state.totalFocusMinutes;
  bool get deepFocusUnlocked => state.deepFocusUnlockedAt(DateTime.now());
  List<FocusSession> get focusSessions => state.focusSessions;

  Map<String, int> focusMinutesByCourse({int days = 30}) {
    return state.focusMinutesByCourse(now: DateTime.now(), days: days);
  }

  Future<void> setFocusGoal(int minutes) => actions.setFocusGoal(minutes);
  Future<void> addFocusSession(FocusSession session) =>
      actions.addFocusSession(session);
}
