class DailyStat {
  const DailyStat({
    required this.dateKey,
    required this.completedTasks,
    required this.totalTasks,
    required this.focusMinutes,
    required this.disciplineScore,
    required this.success,
  });

  final String dateKey;
  final int completedTasks;
  final int totalTasks;
  final int focusMinutes;
  final int disciplineScore;
  final bool success;

  Map<String, dynamic> toJson() {
    return {
      'dateKey': dateKey,
      'completedTasks': completedTasks,
      'totalTasks': totalTasks,
      'focusMinutes': focusMinutes,
      'disciplineScore': disciplineScore,
      'success': success,
    };
  }

  factory DailyStat.fromJson(Map<String, dynamic> json) {
    return DailyStat(
      dateKey: json['dateKey'] as String? ?? '',
      completedTasks: json['completedTasks'] as int? ?? 0,
      totalTasks: json['totalTasks'] as int? ?? 0,
      focusMinutes: json['focusMinutes'] as int? ?? 0,
      disciplineScore: json['disciplineScore'] as int? ?? 60,
      success: json['success'] as bool? ?? false,
    );
  }
}
