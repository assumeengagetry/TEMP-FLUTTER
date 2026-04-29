import '../../app_controller.dart';
import '../../models/study_task.dart';

class TaskController {
  const TaskController({required this.state, required this.actions});

  final StudyAppState state;
  final StudyAppNotifier actions;

  List<String> get courses => state.courses;
  List<StudyTask> get openTasks => state.openTasks;
  int get doneCount => state.doneCount;
  int get totalCount => state.totalCount;
  double get taskProgress => state.taskProgress;
  int get overdueTaskCount => state.overdueTaskCountAt(DateTime.now());

  List<StudyTask> tasksForCourse(String? course) =>
      state.tasksForCourse(course);
  Future<void> addTask(StudyTask task) => actions.addTask(task);
  Future<void> updateTask(StudyTask task) => actions.updateTask(task);
  Future<void> deleteTask(String taskId) => actions.deleteTask(taskId);
  Future<void> toggleTaskDone(String taskId, bool done) =>
      actions.toggleTaskDone(taskId, done);
}
