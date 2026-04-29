import 'package:drift/drift.dart';

import '../../../models/daily_stat.dart';
import '../../../models/focus_session.dart';
import '../../../models/study_task.dart';
import 'app_database.dart';

StudyTask mapTaskRow(Task row) {
  return StudyTask(
    id: row.id,
    title: row.title,
    course: row.course,
    type: StudyTaskTypeX.fromName(row.type),
    priority: StudyTaskPriorityX.fromName(row.priority),
    points: row.points,
    estimatedMinutes: row.estimatedMinutes,
    createdAt: row.createdAt,
    deadline: row.deadline,
    note: row.note,
    proofText: row.proofText,
    proofLink: row.proofLink,
    done: row.done,
    completedAt: row.completedAt,
    overduePenaltyApplied: row.overduePenaltyApplied,
  );
}

TasksCompanion taskToCompanion(StudyTask task) {
  return TasksCompanion.insert(
    id: task.id,
    title: task.title,
    course: task.course,
    type: task.type.name,
    priority: task.priority.name,
    points: task.points,
    estimatedMinutes: task.estimatedMinutes,
    createdAt: task.createdAt,
    deadline: Value(task.deadline),
    note: Value(task.note),
    proofText: Value(task.proofText),
    proofLink: Value(task.proofLink),
    done: Value(task.done),
    completedAt: Value(task.completedAt),
    overduePenaltyApplied: Value(task.overduePenaltyApplied),
  );
}

FocusSession mapFocusSessionRow(FocusSessionRecord row) {
  return FocusSession(
    id: row.id,
    course: row.course,
    mode: FocusMode.values.firstWhere(
      (item) => item.name == row.mode,
      orElse: () => FocusMode.preset,
    ),
    plannedMinutes: row.plannedMinutes,
    actualMinutes: row.actualMinutes,
    completed: row.completed,
    interrupted: row.interrupted,
    startedAt: row.startedAt,
    endedAt: row.endedAt,
  );
}

FocusSessionRecordsCompanion focusSessionToCompanion(FocusSession session) {
  return FocusSessionRecordsCompanion.insert(
    id: session.id,
    course: session.course,
    mode: session.mode.name,
    plannedMinutes: session.plannedMinutes,
    actualMinutes: session.actualMinutes,
    completed: session.completed,
    interrupted: session.interrupted,
    startedAt: session.startedAt,
    endedAt: session.endedAt,
  );
}

DailyStat mapDailyStatRow(DailyStatRecord row) {
  return DailyStat(
    dateKey: row.dateKey,
    completedTasks: row.completedTasks,
    totalTasks: row.totalTasks,
    focusMinutes: row.focusMinutes,
    disciplineScore: row.disciplineScore,
    success: row.success,
  );
}

DailyStatRecordsCompanion dailyStatToCompanion(DailyStat stat) {
  return DailyStatRecordsCompanion.insert(
    dateKey: stat.dateKey,
    completedTasks: stat.completedTasks,
    totalTasks: stat.totalTasks,
    focusMinutes: stat.focusMinutes,
    disciplineScore: stat.disciplineScore,
    success: stat.success,
  );
}
