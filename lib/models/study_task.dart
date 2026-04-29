import 'package:flutter/material.dart';

enum StudyTaskType { review, assignment, coding, reading, lab, exam }

enum StudyTaskPriority { low, medium, high, urgent }

extension StudyTaskTypeX on StudyTaskType {
  String get label {
    return switch (this) {
      StudyTaskType.review => '复习',
      StudyTaskType.assignment => '作业',
      StudyTaskType.coding => '代码',
      StudyTaskType.reading => '阅读',
      StudyTaskType.lab => '实验',
      StudyTaskType.exam => '考试',
    };
  }

  IconData get icon {
    return switch (this) {
      StudyTaskType.review => Icons.auto_stories_rounded,
      StudyTaskType.assignment => Icons.edit_note_rounded,
      StudyTaskType.coding => Icons.code_rounded,
      StudyTaskType.reading => Icons.chrome_reader_mode_rounded,
      StudyTaskType.lab => Icons.science_rounded,
      StudyTaskType.exam => Icons.fact_check_rounded,
    };
  }

  static StudyTaskType fromName(String? name) {
    return StudyTaskType.values.firstWhere(
      (item) => item.name == name,
      orElse: () => StudyTaskType.assignment,
    );
  }
}

extension StudyTaskPriorityX on StudyTaskPriority {
  String get label {
    return switch (this) {
      StudyTaskPriority.low => '低',
      StudyTaskPriority.medium => '中',
      StudyTaskPriority.high => '高',
      StudyTaskPriority.urgent => '紧急',
    };
  }

  Color color(ColorScheme scheme) {
    return switch (this) {
      StudyTaskPriority.low => scheme.secondary,
      StudyTaskPriority.medium => scheme.primary,
      StudyTaskPriority.high => scheme.tertiary,
      StudyTaskPriority.urgent => scheme.error,
    };
  }

  int get suggestedPoints {
    return switch (this) {
      StudyTaskPriority.low => 5,
      StudyTaskPriority.medium => 10,
      StudyTaskPriority.high => 15,
      StudyTaskPriority.urgent => 20,
    };
  }

  static StudyTaskPriority fromName(String? name) {
    return StudyTaskPriority.values.firstWhere(
      (item) => item.name == name,
      orElse: () => StudyTaskPriority.medium,
    );
  }
}

class StudyTask {
  const StudyTask({
    required this.id,
    required this.title,
    required this.course,
    required this.type,
    required this.priority,
    required this.points,
    required this.estimatedMinutes,
    required this.createdAt,
    this.deadline,
    this.note = '',
    this.proofText = '',
    this.proofLink = '',
    this.done = false,
    this.completedAt,
    this.overduePenaltyApplied = false,
  });

  final String id;
  final String title;
  final String course;
  final StudyTaskType type;
  final StudyTaskPriority priority;
  final int points;
  final int estimatedMinutes;
  final DateTime createdAt;
  final DateTime? deadline;
  final String note;
  final String proofText;
  final String proofLink;
  final bool done;
  final DateTime? completedAt;
  final bool overduePenaltyApplied;

  bool isOverdueAt(DateTime now) {
    if (done || deadline == null) return false;
    return deadline!.isBefore(now);
  }

  bool get hasProof =>
      proofText.trim().isNotEmpty || proofLink.trim().isNotEmpty;

  StudyTask copyWith({
    String? id,
    String? title,
    String? course,
    StudyTaskType? type,
    StudyTaskPriority? priority,
    int? points,
    int? estimatedMinutes,
    DateTime? createdAt,
    DateTime? deadline,
    bool clearDeadline = false,
    String? note,
    String? proofText,
    String? proofLink,
    bool? done,
    DateTime? completedAt,
    bool clearCompletedAt = false,
    bool? overduePenaltyApplied,
  }) {
    return StudyTask(
      id: id ?? this.id,
      title: title ?? this.title,
      course: course ?? this.course,
      type: type ?? this.type,
      priority: priority ?? this.priority,
      points: points ?? this.points,
      estimatedMinutes: estimatedMinutes ?? this.estimatedMinutes,
      createdAt: createdAt ?? this.createdAt,
      deadline: clearDeadline ? null : (deadline ?? this.deadline),
      note: note ?? this.note,
      proofText: proofText ?? this.proofText,
      proofLink: proofLink ?? this.proofLink,
      done: done ?? this.done,
      completedAt: clearCompletedAt ? null : (completedAt ?? this.completedAt),
      overduePenaltyApplied:
          overduePenaltyApplied ?? this.overduePenaltyApplied,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'course': course,
      'type': type.name,
      'priority': priority.name,
      'points': points,
      'estimatedMinutes': estimatedMinutes,
      'createdAt': createdAt.toIso8601String(),
      'deadline': deadline?.toIso8601String(),
      'note': note,
      'proofText': proofText,
      'proofLink': proofLink,
      'done': done,
      'completedAt': completedAt?.toIso8601String(),
      'overduePenaltyApplied': overduePenaltyApplied,
    };
  }

  factory StudyTask.fromJson(Map<String, dynamic> json) {
    return StudyTask(
      id:
          json['id'] as String? ??
          DateTime.now().microsecondsSinceEpoch.toString(),
      title: json['title'] as String? ?? '未命名任务',
      course: json['course'] as String? ?? '其他',
      type: StudyTaskTypeX.fromName(json['type'] as String?),
      priority: StudyTaskPriorityX.fromName(json['priority'] as String?),
      points: json['points'] as int? ?? 10,
      estimatedMinutes: json['estimatedMinutes'] as int? ?? 25,
      createdAt:
          DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime.now(),
      deadline: DateTime.tryParse(json['deadline'] as String? ?? ''),
      note: json['note'] as String? ?? '',
      proofText: json['proofText'] as String? ?? '',
      proofLink: json['proofLink'] as String? ?? '',
      done: json['done'] as bool? ?? false,
      completedAt: DateTime.tryParse(json['completedAt'] as String? ?? ''),
      overduePenaltyApplied: json['overduePenaltyApplied'] as bool? ?? false,
    );
  }
}
