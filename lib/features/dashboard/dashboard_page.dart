import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app_providers.dart';
import '../../core/utils/date_utils.dart';
import '../../models/study_task.dart';
import '../focus/focus_controller.dart';
import '../stats/stats_controller.dart';
import '../tasks/task_controller.dart';

enum _TaskFilter { all, open, overdue, completed }

class DashboardPage extends ConsumerStatefulWidget {
  const DashboardPage({super.key});

  @override
  ConsumerState<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends ConsumerState<DashboardPage> {
  String _selectedCourse = '全部';
  _TaskFilter _taskFilter = _TaskFilter.all;

  @override
  Widget build(BuildContext context) {
    final taskController = ref.watch(taskControllerProvider);
    final focusController = ref.watch(focusControllerProvider);
    final statsController = ref.watch(statsControllerProvider);
    final scheme = Theme.of(context).colorScheme;
    final allCourses = ['全部', ...taskController.courses];
    var tasks = taskController.tasksForCourse(_selectedCourse);
    tasks.sort((a, b) {
      if (a.done != b.done) {
        return a.done ? 1 : -1;
      }
      if (a.priority != b.priority) {
        return b.priority.index.compareTo(a.priority.index);
      }
      if (a.deadline == null && b.deadline == null) return 0;
      if (a.deadline == null) return 1;
      if (b.deadline == null) return -1;
      return a.deadline!.compareTo(b.deadline!);
    });

    tasks = switch (_taskFilter) {
      _TaskFilter.all => tasks,
      _TaskFilter.open => tasks.where((item) => !item.done).toList(),
      _TaskFilter.overdue =>
        tasks.where((item) => item.isOverdueAt(DateTime.now())).toList(),
      _TaskFilter.completed => tasks.where((item) => item.done).toList(),
    };

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 12, 18, 8),
            child: _DashboardHero(
              taskController: taskController,
              focusController: focusController,
              statsController: statsController,
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
            child: Row(
              children: [
                Text(
                  '课程筛选',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const Spacer(),
                FilledButton.tonalIcon(
                  onPressed: () => _openTaskEditor(context),
                  icon: const Icon(Icons.add_rounded),
                  label: const Text('新增任务'),
                ),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: SizedBox(
            height: 54,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 18),
              itemBuilder: (context, index) {
                final course = allCourses[index];
                return FilterChip(
                  label: Text(course),
                  selected: _selectedCourse == course,
                  onSelected: (_) => setState(() => _selectedCourse = course),
                );
              },
              separatorBuilder: (context, index) => const SizedBox(width: 8),
              itemCount: allCourses.length,
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 10, 18, 6),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildFilterChip('全部', _TaskFilter.all),
                _buildFilterChip('待完成', _TaskFilter.open),
                _buildFilterChip('已逾期', _TaskFilter.overdue),
                _buildFilterChip('已完成', _TaskFilter.completed),
              ],
            ),
          ),
        ),
        if (tasks.isEmpty)
          SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.assignment_turned_in_rounded,
                      size: 72,
                      color: scheme.primary,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '当前筛选下没有任务',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '可以新建一个课程任务，或者切换筛选查看全部任务。',
                      style: TextStyle(color: scheme.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
            ),
          )
        else
          SliverList.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              return Padding(
                padding: EdgeInsets.fromLTRB(
                  18,
                  index == 0 ? 8 : 4,
                  18,
                  index == tasks.length - 1 ? 100 : 4,
                ),
                child: _TaskCard(
                  task: task,
                  onToggleDone: (value) =>
                      taskController.toggleTaskDone(task.id, value),
                  onEdit: () => _openTaskEditor(context, task: task),
                  onDelete: () => taskController.deleteTask(task.id),
                ),
              );
            },
          ),
      ],
    );
  }

  Widget _buildFilterChip(String label, _TaskFilter filter) {
    return ChoiceChip(
      label: Text(label),
      selected: _taskFilter == filter,
      onSelected: (_) => setState(() => _taskFilter = filter),
    );
  }

  Future<void> _openTaskEditor(BuildContext context, {StudyTask? task}) async {
    final taskController = ref.read(taskControllerProvider);
    final result = await showDialog<StudyTask>(
      context: context,
      builder: (context) => _TaskEditorDialog(task: task),
    );
    if (!context.mounted || result == null) return;

    if (task == null) {
      await taskController.addTask(result);
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('任务已添加')));
      return;
    }

    await taskController.updateTask(result);
    if (!context.mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('任务已更新')));
  }
}

class _DashboardHero extends StatelessWidget {
  const _DashboardHero({
    required this.taskController,
    required this.focusController,
    required this.statsController,
  });

  final TaskController taskController;
  final FocusController focusController;
  final StatsController statsController;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final dueSoon = taskController.openTasks.where((item) {
      if (item.deadline == null) return false;
      final diff = item.deadline!.difference(DateTime.now()).inHours;
      return diff >= 0 && diff <= 24;
    }).length;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [scheme.primaryContainer, scheme.secondaryContainer],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '今天 ${AppDateUtils.formatDate(DateTime.now())}',
            style: TextStyle(
              color: scheme.onPrimaryContainer.withValues(alpha: 0.8),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            statsController.disciplineLabel,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w900,
              color: scheme.onPrimaryContainer,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '任务完成 ${taskController.doneCount}/${taskController.totalCount}，今日专注 ${focusController.todayFocusMinutes}/${focusController.focusGoalMinutes} 分钟。',
            style: TextStyle(
              color: scheme.onPrimaryContainer.withValues(alpha: 0.82),
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: _MetricTile(
                  label: '自律分',
                  value: '${statsController.selfDisciplineScore}',
                  icon: Icons.psychology_rounded,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _MetricTile(
                  label: '连续打卡',
                  value: '${statsController.currentStreak} 天',
                  icon: Icons.local_fire_department_rounded,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _MetricTile(
                  label: '逾期任务',
                  value: '${taskController.overdueTaskCount}',
                  icon: Icons.warning_amber_rounded,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _MetricTile(
                  label: '24h 截止',
                  value: '$dueSoon',
                  icon: Icons.alarm_rounded,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          LinearProgressIndicator(
            value: taskController.taskProgress,
            minHeight: 12,
            borderRadius: BorderRadius.circular(999),
          ),
        ],
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: scheme.surface.withValues(alpha: 0.56),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: scheme.primary),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(color: scheme.onSurfaceVariant, fontSize: 12),
          ),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }
}

class _TaskCard extends StatelessWidget {
  const _TaskCard({
    required this.task,
    required this.onToggleDone,
    required this.onEdit,
    required this.onDelete,
  });

  final StudyTask task;
  final ValueChanged<bool> onToggleDone;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final overdue = task.isOverdueAt(DateTime.now());

    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Checkbox(
                  value: task.done,
                  onChanged: (value) => onToggleDone(value ?? false),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.title,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              fontWeight: FontWeight.w800,
                              decoration: task.done
                                  ? TextDecoration.lineThrough
                                  : null,
                              color: task.done
                                  ? scheme.onSurfaceVariant
                                  : scheme.onSurface,
                            ),
                      ),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 8,
                        runSpacing: 6,
                        children: [
                          Chip(
                            label: Text(task.course),
                            avatar: const Icon(
                              Icons.menu_book_rounded,
                              size: 16,
                            ),
                            visualDensity: VisualDensity.compact,
                          ),
                          Chip(
                            label: Text(task.type.label),
                            avatar: Icon(task.type.icon, size: 16),
                            visualDensity: VisualDensity.compact,
                          ),
                          Chip(
                            label: Text('${task.estimatedMinutes} 分钟'),
                            avatar: const Icon(
                              Icons.schedule_rounded,
                              size: 16,
                            ),
                            visualDensity: VisualDensity.compact,
                          ),
                          Chip(
                            label: Text(task.priority.label),
                            avatar: Icon(
                              Icons.flag_rounded,
                              size: 16,
                              color: task.priority.color(scheme),
                            ),
                            visualDensity: VisualDensity.compact,
                          ),
                          Chip(
                            label: Text('+${task.points}'),
                            avatar: const Icon(Icons.stars_rounded, size: 16),
                            visualDensity: VisualDensity.compact,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'edit') onEdit();
                    if (value == 'delete') onDelete();
                  },
                  itemBuilder: (context) => const [
                    PopupMenuItem(value: 'edit', child: Text('编辑')),
                    PopupMenuItem(value: 'delete', child: Text('删除')),
                  ],
                ),
              ],
            ),
            if (task.deadline != null || task.note.isNotEmpty || task.hasProof)
              Padding(
                padding: const EdgeInsets.only(left: 50, top: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (task.deadline != null)
                      Row(
                        children: [
                          Icon(
                            overdue
                                ? Icons.warning_amber_rounded
                                : Icons.event_rounded,
                            size: 18,
                            color: overdue ? scheme.error : scheme.primary,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            overdue
                                ? '已逾期：${AppDateUtils.formatDateTime(task.deadline!)}'
                                : '截止：${AppDateUtils.formatDateTime(task.deadline!)}',
                            style: TextStyle(
                              color: overdue
                                  ? scheme.error
                                  : scheme.onSurfaceVariant,
                              fontWeight: overdue
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    if (task.note.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        '备注：${task.note}',
                        style: TextStyle(color: scheme.onSurfaceVariant),
                      ),
                    ],
                    if (task.hasProof) ...[
                      const SizedBox(height: 8),
                      Text(
                        '完成证明：${task.proofText.isEmpty ? '已填写链接' : task.proofText}',
                        style: TextStyle(color: scheme.onSurfaceVariant),
                      ),
                    ],
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _TaskEditorDialog extends StatefulWidget {
  const _TaskEditorDialog({this.task});

  final StudyTask? task;

  @override
  State<_TaskEditorDialog> createState() => _TaskEditorDialogState();
}

class _TaskEditorDialogState extends State<_TaskEditorDialog> {
  late final TextEditingController _titleController;
  late final TextEditingController _courseController;
  late final TextEditingController _noteController;
  late final TextEditingController _proofTextController;
  late final TextEditingController _proofLinkController;
  late StudyTaskType _type;
  late StudyTaskPriority _priority;
  late int _estimatedMinutes;
  late int _points;
  DateTime? _deadline;

  @override
  void initState() {
    super.initState();
    final task = widget.task;
    _titleController = TextEditingController(text: task?.title ?? '');
    _courseController = TextEditingController(text: task?.course ?? '操作系统');
    _noteController = TextEditingController(text: task?.note ?? '');
    _proofTextController = TextEditingController(text: task?.proofText ?? '');
    _proofLinkController = TextEditingController(text: task?.proofLink ?? '');
    _type = task?.type ?? StudyTaskType.assignment;
    _priority = task?.priority ?? StudyTaskPriority.medium;
    _estimatedMinutes = task?.estimatedMinutes ?? 25;
    _points = task?.points ?? _priority.suggestedPoints;
    _deadline = task?.deadline;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _courseController.dispose();
    _noteController.dispose();
    _proofTextController.dispose();
    _proofLinkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.task == null ? '新增监督任务' : '编辑监督任务'),
      content: SizedBox(
        width: 520,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: '任务标题'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _courseController,
                decoration: const InputDecoration(labelText: '课程 / 分类'),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<StudyTaskType>(
                initialValue: _type,
                decoration: const InputDecoration(labelText: '任务类型'),
                items: StudyTaskType.values.map((item) {
                  return DropdownMenuItem(value: item, child: Text(item.label));
                }).toList(),
                onChanged: (value) {
                  if (value == null) return;
                  setState(() => _type = value);
                },
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<StudyTaskPriority>(
                initialValue: _priority,
                decoration: const InputDecoration(labelText: '优先级'),
                items: StudyTaskPriority.values.map((item) {
                  return DropdownMenuItem(value: item, child: Text(item.label));
                }).toList(),
                onChanged: (value) {
                  if (value == null) return;
                  setState(() {
                    _priority = value;
                    _points = value.suggestedPoints;
                  });
                },
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<int>(
                initialValue: _estimatedMinutes,
                decoration: const InputDecoration(labelText: '预计用时'),
                items: const [15, 25, 45, 60, 90]
                    .map(
                      (item) => DropdownMenuItem(
                        value: item,
                        child: Text('$item 分钟'),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value == null) return;
                  setState(() => _estimatedMinutes = value);
                },
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Text('积分'),
                  Expanded(
                    child: Slider(
                      value: _points.toDouble(),
                      min: 5,
                      max: 20,
                      divisions: 3,
                      label: '$_points',
                      onChanged: (value) =>
                          setState(() => _points = value.round()),
                    ),
                  ),
                  Text('$_points'),
                ],
              ),
              const SizedBox(height: 8),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.event_rounded),
                title: Text(
                  _deadline == null
                      ? '未设置截止时间'
                      : '截止：${AppDateUtils.formatDateTime(_deadline!)}',
                ),
                subtitle: const Text('用于逾期扣分和优先级排序'),
                trailing: Wrap(
                  spacing: 8,
                  children: [
                    if (_deadline != null)
                      IconButton(
                        onPressed: () => setState(() => _deadline = null),
                        icon: const Icon(Icons.close_rounded),
                      ),
                    IconButton(
                      onPressed: _pickDeadline,
                      icon: const Icon(Icons.edit_calendar_rounded),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _noteController,
                maxLines: 2,
                decoration: const InputDecoration(labelText: '备注'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _proofTextController,
                decoration: const InputDecoration(labelText: '完成证明说明'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _proofLinkController,
                decoration: const InputDecoration(labelText: '证明链接'),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('取消'),
        ),
        FilledButton(
          onPressed: _submit,
          child: Text(widget.task == null ? '添加' : '保存'),
        ),
      ],
    );
  }

  Future<void> _pickDeadline() async {
    final today = DateTime.now();
    final initialDate = _deadline ?? today;
    final date = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: today.subtract(const Duration(days: 365)),
      lastDate: today.add(const Duration(days: 365 * 3)),
    );
    if (date == null || !mounted) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(
        _deadline ?? DateTime(today.year, today.month, today.day, 21),
      ),
    );
    if (!mounted) return;
    setState(() {
      _deadline = DateTime(
        date.year,
        date.month,
        date.day,
        time?.hour ?? 23,
        time?.minute ?? 59,
      );
    });
  }

  void _submit() {
    final title = _titleController.text.trim();
    final course = _courseController.text.trim();
    if (title.isEmpty || course.isEmpty) return;

    final existing = widget.task;
    Navigator.pop(
      context,
      StudyTask(
        id: existing?.id ?? DateTime.now().microsecondsSinceEpoch.toString(),
        title: title,
        course: course,
        type: _type,
        priority: _priority,
        points: _points,
        estimatedMinutes: _estimatedMinutes,
        createdAt: existing?.createdAt ?? DateTime.now(),
        deadline: _deadline,
        note: _noteController.text.trim(),
        proofText: _proofTextController.text.trim(),
        proofLink: _proofLinkController.text.trim(),
        done: existing?.done ?? false,
        completedAt: existing?.completedAt,
        overduePenaltyApplied: existing?.overduePenaltyApplied ?? false,
      ),
    );
  }
}
