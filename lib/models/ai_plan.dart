class AiPlanBlock {
  const AiPlanBlock({
    required this.timeLabel,
    required this.taskLabel,
    required this.modeLabel,
  });

  final String timeLabel;
  final String taskLabel;
  final String modeLabel;
}

class AiPlanSuggestion {
  const AiPlanSuggestion({
    required this.summary,
    required this.risk,
    required this.blocks,
    required this.weeklyReview,
  });

  final String summary;
  final String risk;
  final List<AiPlanBlock> blocks;
  final String weeklyReview;
}
