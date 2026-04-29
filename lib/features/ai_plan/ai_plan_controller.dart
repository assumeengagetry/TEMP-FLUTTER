import '../../app_controller.dart';
import '../../models/ai_plan.dart';

class AiPlanController {
  const AiPlanController({required this.state});

  final StudyAppState state;

  int get focusGoalMinutes => state.focusGoalMinutes;

  AiPlanSuggestion generateAiPlan({required int availableMinutes}) {
    return state.generateAiPlan(
      availableMinutes: availableMinutes,
      now: DateTime.now(),
    );
  }
}
