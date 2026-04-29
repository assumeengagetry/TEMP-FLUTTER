import 'package:flutter/material.dart';

import 'daily_stat.dart';
import 'focus_session.dart';
import 'study_task.dart';

class AppStateSnapshot {
  const AppStateSnapshot({
    required this.lastActiveDateKey,
    required this.selfDisciplineScore,
    required this.focusGoalMinutes,
    required this.themeModeName,
    required this.tasks,
    required this.focusSessions,
    required this.dailyStats,
  });

  final String lastActiveDateKey;
  final int selfDisciplineScore;
  final int focusGoalMinutes;
  final String themeModeName;
  final List<StudyTask> tasks;
  final List<FocusSession> focusSessions;
  final List<DailyStat> dailyStats;

  ThemeMode get themeMode {
    return ThemeMode.values.firstWhere(
      (item) => item.name == themeModeName,
      orElse: () => ThemeMode.system,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lastActiveDateKey': lastActiveDateKey,
      'selfDisciplineScore': selfDisciplineScore,
      'focusGoalMinutes': focusGoalMinutes,
      'themeModeName': themeModeName,
      'tasks': tasks.map((item) => item.toJson()).toList(),
      'focusSessions': focusSessions.map((item) => item.toJson()).toList(),
      'dailyStats': dailyStats.map((item) => item.toJson()).toList(),
    };
  }

  factory AppStateSnapshot.fromJson(Map<String, dynamic> json) {
    return AppStateSnapshot(
      lastActiveDateKey: json['lastActiveDateKey'] as String? ?? '',
      selfDisciplineScore: json['selfDisciplineScore'] as int? ?? 60,
      focusGoalMinutes: json['focusGoalMinutes'] as int? ?? 60,
      themeModeName: json['themeModeName'] as String? ?? ThemeMode.system.name,
      tasks: (json['tasks'] as List<dynamic>? ?? [])
          .map((item) => StudyTask.fromJson(item as Map<String, dynamic>))
          .toList(),
      focusSessions: (json['focusSessions'] as List<dynamic>? ?? [])
          .map((item) => FocusSession.fromJson(item as Map<String, dynamic>))
          .toList(),
      dailyStats: (json['dailyStats'] as List<dynamic>? ?? [])
          .map((item) => DailyStat.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}
