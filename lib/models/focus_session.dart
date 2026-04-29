enum FocusMode { preset, free }

class FocusSession {
  const FocusSession({
    required this.id,
    required this.course,
    required this.mode,
    required this.plannedMinutes,
    required this.actualMinutes,
    required this.completed,
    required this.interrupted,
    required this.startedAt,
    required this.endedAt,
  });

  final String id;
  final String course;
  final FocusMode mode;
  final int plannedMinutes;
  final int actualMinutes;
  final bool completed;
  final bool interrupted;
  final DateTime startedAt;
  final DateTime endedAt;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'course': course,
      'mode': mode.name,
      'plannedMinutes': plannedMinutes,
      'actualMinutes': actualMinutes,
      'completed': completed,
      'interrupted': interrupted,
      'startedAt': startedAt.toIso8601String(),
      'endedAt': endedAt.toIso8601String(),
    };
  }

  factory FocusSession.fromJson(Map<String, dynamic> json) {
    return FocusSession(
      id:
          json['id'] as String? ??
          DateTime.now().microsecondsSinceEpoch.toString(),
      course: json['course'] as String? ?? '通用自习',
      mode: FocusMode.values.firstWhere(
        (item) => item.name == json['mode'],
        orElse: () => FocusMode.preset,
      ),
      plannedMinutes: json['plannedMinutes'] as int? ?? 25,
      actualMinutes: json['actualMinutes'] as int? ?? 0,
      completed: json['completed'] as bool? ?? false,
      interrupted: json['interrupted'] as bool? ?? false,
      startedAt:
          DateTime.tryParse(json['startedAt'] as String? ?? '') ??
          DateTime.now(),
      endedAt:
          DateTime.tryParse(json['endedAt'] as String? ?? '') ?? DateTime.now(),
    );
  }
}
