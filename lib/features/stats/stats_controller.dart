import '../../app_controller.dart';
import '../../models/daily_stat.dart';

class StatsController {
  const StatsController({required this.state});

  final StudyAppState state;

  List<DailyStat> get recentSevenStats =>
      state.recentSevenStatsAt(DateTime.now());
  List<DailyStat> get storedDailyStats => state.dailyStats;
  int get currentStreak => state.currentStreakAt(DateTime.now());
  int get totalFocusMinutes => state.totalFocusMinutes;
  int get todayFocusMinutes => state.todayFocusMinutesAt(DateTime.now());
  int get focusGoalMinutes => state.focusGoalMinutes;
  int get overdueTaskCount => state.overdueTaskCountAt(DateTime.now());
  int get doneCount => state.doneCount;
  int get totalCount => state.totalCount;
  int get selfDisciplineScore => state.selfDisciplineScore;
  String get disciplineLabel => state.disciplineLabel;
  String get weeklyReview => state.weeklyReviewAt(DateTime.now());

  Map<String, int> focusMinutesByCourse({int days = 30}) {
    return state.focusMinutesByCourse(now: DateTime.now(), days: days);
  }
}
