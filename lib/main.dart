import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const StudySupervisorApp());
}

class StudySupervisorApp extends StatefulWidget {
  const StudySupervisorApp({super.key});

  @override
  State<StudySupervisorApp> createState() => _StudySupervisorAppState();
}

class _StudySupervisorAppState extends State<StudySupervisorApp> {
  ThemeMode _themeMode = ThemeMode.system;

  void _toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '大学生学习监督',
      themeMode: _themeMode,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.cyanAccent,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: StudyHomePage(onToggleTheme: _toggleTheme),
    );
  }
}

class StudyHomePage extends StatefulWidget {
  const StudyHomePage({super.key, required this.onToggleTheme});

  final VoidCallback onToggleTheme;

  @override
  State<StudyHomePage> createState() => _StudyHomePageState();
}

class _StudyHomePageState extends State<StudyHomePage> {
  static const String _storageKey = 'college_study_supervisor_v1';

  int _pageIndex = 0;
  String _selectedCourse = '全部';
  bool _loading = true;
  List<StudyTask> _tasks = [];
  Set<String> _completedDates = {};
  int _todayFocusMinutes = 0;
  int _totalFocusMinutes = 0;
  int _selfDisciplineScore = 0;

  String get _todayKey {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  List<String> get _courses {
    final names = _tasks.map((task) => task.course).toSet().toList()..sort();
    return ['全部', ...names];
  }

  List<StudyTask> get _visibleTasks {
    if (_selectedCourse == '全部') return _tasks;
    return _tasks.where((task) => task.course == _selectedCourse).toList();
  }

  int get _doneCount => _tasks.where((task) => task.done).length;

  int get _totalPoints => _tasks.fold(0, (sum, task) => sum + task.points);

  int get _donePoints {
    return _tasks.where((task) => task.done).fold(0, (sum, task) => sum + task.points);
  }

  double get _taskProgress {
    if (_tasks.isEmpty) return 0;
    return _doneCount / _tasks.length;
  }

  int get _streak {
    var count = 0;
    var cursor = DateTime.now();
    while (true) {
      final key = '${cursor.year}-${cursor.month.toString().padLeft(2, '0')}-${cursor.day.toString().padLeft(2, '0')}';
      if (!_completedDates.contains(key)) break;
      count++;
      cursor = cursor.subtract(const Duration(days: 1));
    }
    return count;
  }

  @override
  void initState() {
    super.initState();
    _loadState();
  }

  Future<void> _loadState() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_storageKey);

    if (raw == null) {
      setState(() {
        _tasks = _defaultTasks();
        _selfDisciplineScore = 60;
        _loading = false;
      });
      await _saveState();
      return;
    }

    try {
      final data = jsonDecode(raw) as Map<String, dynamic>;
      final date = data['date'] as String?;
      final savedTasks = (data['tasks'] as List<dynamic>? ?? [])
          .map((item) => StudyTask.fromJson(item as Map<String, dynamic>))
          .toList();
      final dates = (data['completedDates'] as List<dynamic>? ?? []).cast<String>().toSet();

      setState(() {
        _tasks = date == _todayKey && savedTasks.isNotEmpty ? savedTasks : _defaultTasks();
        _completedDates = dates;
        _todayFocusMinutes = date == _todayKey ? (data['todayFocusMinutes'] as int? ?? 0) : 0;
        _totalFocusMinutes = data['totalFocusMinutes'] as int? ?? 0;
        _selfDisciplineScore = data['selfDisciplineScore'] as int? ?? 60;
        _loading = false;
      });
      await _saveState();
    } catch (_) {
      setState(() {
        _tasks = _defaultTasks();
        _selfDisciplineScore = 60;
        _loading = false;
      });
      await _saveState();
    }
  }

  Future<void> _saveState() async {
    final prefs = await SharedPreferences.getInstance();
    final data = {
      'date': _todayKey,
      'tasks': _tasks.map((task) => task.toJson()).toList(),
      'completedDates': _completedDates.toList()..sort(),
      'todayFocusMinutes': _todayFocusMinutes,
      'totalFocusMinutes': _totalFocusMinutes,
      'selfDisciplineScore': _selfDisciplineScore,
    };
    await prefs.setString(_storageKey, jsonEncode(data));
  }

  void _toggleTask(StudyTask task, bool value) {
    setState(() {
      task.done = value;
      _selfDisciplineScore += value ? task.points : -task.points;
      _selfDisciplineScore = _selfDisciplineScore.clamp(0, 100);
      _refreshCompletionDate();
    });
    _saveState();
  }

  void _refreshCompletionDate() {
    final taskFinished = _tasks.isNotEmpty && _tasks.every((task) => task.done);
    final focusFinished = _todayFocusMinutes >= 60;
    if (taskFinished && focusFinished) {
      _completedDates.add(_todayKey);
    } else {
      _completedDates.remove(_todayKey);
    }
  }

  void _addFocusMinutes(int minutes) {
    setState(() {
      _todayFocusMinutes += minutes;
      _totalFocusMinutes += minutes;
      _selfDisciplineScore += math.max(2, minutes ~/ 5);
      _selfDisciplineScore = _selfDisciplineScore.clamp(0, 100);
      _refreshCompletionDate();
    });
    _saveState();
  }

  void _penalizeFocusQuit() {
    setState(() {
      _selfDisciplineScore = (_selfDisciplineScore - 5).clamp(0, 100);
    });
    _saveState();
  }

  void _resetToday() {
    setState(() {
      for (final task in _tasks) {
        task.done = false;
      }
      _todayFocusMinutes = 0;
      _completedDates.remove(_todayKey);
      _selfDisciplineScore = math.max(40, _selfDisciplineScore - 10);
    });
    _saveState();
  }

  Future<void> _addTaskDialog() async {
    final titleController = TextEditingController();
    final courseController = TextEditingController(text: _selectedCourse == '全部' ? '操作系统' : _selectedCourse);
    int points = 10;
    StudyTaskType type = StudyTaskType.assignment;

    final result = await showDialog<StudyTask>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('添加监督任务'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        labelText: '任务名',
                        hintText: '例如：完成计网实验报告',
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: courseController,
                      decoration: const InputDecoration(
                        labelText: '课程 / 分类',
                        hintText: '例如：计算机网络',
                      ),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<StudyTaskType>(
                      value: type,
                      decoration: const InputDecoration(labelText: '任务类型'),
                      items: StudyTaskType.values.map((item) {
                        return DropdownMenuItem(
                          value: item,
                          child: Text(item.label),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) setDialogState(() => type = value);
                      },
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        const Text('自律积分'),
                        Expanded(
                          child: Slider(
                            value: points.toDouble(),
                            min: 5,
                            max: 30,
                            divisions: 5,
                            label: '$points',
                            onChanged: (value) {
                              setDialogState(() => points = value.round());
                            },
                          ),
                        ),
                        Text('$points'),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('取消'),
                ),
                FilledButton(
                  onPressed: () {
                    final title = titleController.text.trim();
                    final course = courseController.text.trim();
                    if (title.isEmpty || course.isEmpty) return;
                    Navigator.pop(
                      context,
                      StudyTask(
                        id: DateTime.now().microsecondsSinceEpoch.toString(),
                        title: title,
                        course: course,
                        type: type,
                        points: points,
                      ),
                    );
                  },
                  child: const Text('添加'),
                ),
              ],
            );
          },
        );
      },
    );

    titleController.dispose();
    courseController.dispose();

    if (result != null) {
      setState(() => _tasks.add(result));
      _saveState();
    }
  }

  void _deleteTask(StudyTask task) {
    setState(() {
      _tasks.removeWhere((item) => item.id == task.id);
      _refreshCompletionDate();
    });
    _saveState();
  }

  List<StudyTask> _defaultTasks() {
    return [
      StudyTask(
        id: 'os-1',
        title: '复习 CPU 调度算法，画一张甘特图',
        course: '操作系统',
        type: StudyTaskType.review,
        points: 10,
      ),
      StudyTask(
        id: 'os-2',
        title: '整理线程池 / 协程库实验代码',
        course: '操作系统',
        type: StudyTaskType.coding,
        points: 15,
      ),
      StudyTask(
        id: 'net-1',
        title: '画出综合布线六大子系统关系图',
        course: '计算机网络',
        type: StudyTaskType.review,
        points: 10,
      ),
      StudyTask(
        id: 'net-2',
        title: '完成交换机 VLAN 实验报告截图说明',
        course: '计算机网络',
        type: StudyTaskType.assignment,
        points: 15,
      ),
      StudyTask(
        id: 'se-1',
        title: '补充 ERP 需求分析报告',
        course: '软件工程',
        type: StudyTaskType.assignment,
        points: 20,
      ),
      StudyTask(
        id: 'flutter-1',
        title: '跑通一个 Flutter 官方 sample 并改一个页面',
        course: 'Flutter',
        type: StudyTaskType.coding,
        points: 20,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      _DashboardPage(
        loading: _loading,
        todayKey: _todayKey,
        visibleTasks: _visibleTasks,
        courses: _courses,
        selectedCourse: _selectedCourse,
        doneCount: _doneCount,
        totalCount: _tasks.length,
        donePoints: _donePoints,
        totalPoints: _totalPoints,
        taskProgress: _taskProgress,
        todayFocusMinutes: _todayFocusMinutes,
        selfDisciplineScore: _selfDisciplineScore,
        onCourseSelected: (course) => setState(() => _selectedCourse = course),
        onTaskChanged: _toggleTask,
        onTaskDeleted: _deleteTask,
        onAddTask: _addTaskDialog,
      ),
      _FocusPage(
        todayFocusMinutes: _todayFocusMinutes,
        onFocusCompleted: _addFocusMinutes,
        onQuitEarly: _penalizeFocusQuit,
      ),
      _StatsPage(
        completedDates: _completedDates,
        streak: _streak,
        donePoints: _donePoints,
        totalPoints: _totalPoints,
        doneCount: _doneCount,
        totalCount: _tasks.length,
        todayFocusMinutes: _todayFocusMinutes,
        totalFocusMinutes: _totalFocusMinutes,
        selfDisciplineScore: _selfDisciplineScore,
      ),
      _SettingsPage(
        onToggleTheme: widget.onToggleTheme,
        onResetToday: _resetToday,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('大学生学习监督'),
        actions: [
          IconButton(
            tooltip: '切换明暗主题',
            onPressed: widget.onToggleTheme,
            icon: const Icon(Icons.brightness_6_rounded),
          ),
        ],
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 280),
        child: pages[_pageIndex],
      ),
      floatingActionButton: _pageIndex == 0
          ? FloatingActionButton.extended(
        onPressed: _addTaskDialog,
        icon: const Icon(Icons.add_rounded),
        label: const Text('添加任务'),
      )
          : null,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _pageIndex,
        onDestinationSelected: (index) => setState(() => _pageIndex = index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard_rounded),
            label: '监督台',
          ),
          NavigationDestination(
            icon: Icon(Icons.timer_outlined),
            selectedIcon: Icon(Icons.timer_rounded),
            label: '专注',
          ),
          NavigationDestination(
            icon: Icon(Icons.insights_rounded),
            label: '统计',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_rounded),
            label: '设置',
          ),
        ],
      ),
    );
  }
}

class _DashboardPage extends StatelessWidget {
  const _DashboardPage({
    required this.loading,
    required this.todayKey,
    required this.visibleTasks,
    required this.courses,
    required this.selectedCourse,
    required this.doneCount,
    required this.totalCount,
    required this.donePoints,
    required this.totalPoints,
    required this.taskProgress,
    required this.todayFocusMinutes,
    required this.selfDisciplineScore,
    required this.onCourseSelected,
    required this.onTaskChanged,
    required this.onTaskDeleted,
    required this.onAddTask,
  });

  final bool loading;
  final String todayKey;
  final List<StudyTask> visibleTasks;
  final List<String> courses;
  final String selectedCourse;
  final int doneCount;
  final int totalCount;
  final int donePoints;
  final int totalPoints;
  final double taskProgress;
  final int todayFocusMinutes;
  final int selfDisciplineScore;
  final ValueChanged<String> onCourseSelected;
  final void Function(StudyTask task, bool value) onTaskChanged;
  final ValueChanged<StudyTask> onTaskDeleted;
  final VoidCallback onAddTask;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 12, 18, 8),
            child: _SupervisorHeroCard(
              todayKey: todayKey,
              doneCount: doneCount,
              totalCount: totalCount,
              donePoints: donePoints,
              totalPoints: totalPoints,
              taskProgress: taskProgress,
              todayFocusMinutes: todayFocusMinutes,
              selfDisciplineScore: selfDisciplineScore,
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 8, 18, 6),
            child: Text(
              '课程筛选',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: SizedBox(
            height: 54,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                final course = courses[index];
                return FilterChip(
                  label: Text(course),
                  selected: selectedCourse == course,
                  onSelected: (_) => onCourseSelected(course),
                );
              },
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemCount: courses.length,
            ),
          ),
        ),
        if (visibleTasks.isEmpty)
          SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.inbox_rounded, size: 72, color: scheme.primary),
                    const SizedBox(height: 16),
                    Text('这个分类还没有任务', style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 8),
                    Text('可以添加一个课程监督任务。', style: TextStyle(color: scheme.onSurfaceVariant)),
                    const SizedBox(height: 16),
                    FilledButton.icon(
                      onPressed: onAddTask,
                      icon: const Icon(Icons.add_rounded),
                      label: const Text('添加任务'),
                    ),
                  ],
                ),
              ),
            ),
          )
        else
          SliverList.builder(
            itemCount: visibleTasks.length,
            itemBuilder: (context, index) {
              final task = visibleTasks[index];
              return Padding(
                padding: EdgeInsets.fromLTRB(18, index == 0 ? 8 : 4, 18, index == visibleTasks.length - 1 ? 100 : 4),
                child: _TaskCard(
                  task: task,
                  onChanged: (value) => onTaskChanged(task, value),
                  onDeleted: () => onTaskDeleted(task),
                ),
              );
            },
          ),
      ],
    );
  }
}

class _SupervisorHeroCard extends StatelessWidget {
  const _SupervisorHeroCard({
    required this.todayKey,
    required this.doneCount,
    required this.totalCount,
    required this.donePoints,
    required this.totalPoints,
    required this.taskProgress,
    required this.todayFocusMinutes,
    required this.selfDisciplineScore,
  });

  final String todayKey;
  final int doneCount;
  final int totalCount;
  final int donePoints;
  final int totalPoints;
  final double taskProgress;
  final int todayFocusMinutes;
  final int selfDisciplineScore;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final status = selfDisciplineScore >= 85
        ? '状态优秀，继续保持'
        : selfDisciplineScore >= 60
        ? '状态稳定，还能再冲'
        : '注意摸鱼风险，需要补救';

    return Card(
      elevation: 0,
      color: scheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('今天：$todayKey', style: TextStyle(color: scheme.onPrimaryContainer.withOpacity(0.78))),
            const SizedBox(height: 10),
            Text(
              status,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w900,
                color: scheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: _MiniMetric(
                    icon: Icons.task_alt_rounded,
                    label: '任务完成',
                    value: '$doneCount/$totalCount',
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _MiniMetric(
                    icon: Icons.timer_rounded,
                    label: '今日专注',
                    value: '$todayFocusMinutes 分钟',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _MiniMetric(
                    icon: Icons.stars_rounded,
                    label: '任务积分',
                    value: '$donePoints/$totalPoints',
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _MiniMetric(
                    icon: Icons.psychology_rounded,
                    label: '自律分',
                    value: '$selfDisciplineScore/100',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: taskProgress),
              duration: const Duration(milliseconds: 650),
              curve: Curves.easeOutBack,
              builder: (context, value, _) {
                return LinearProgressIndicator(
                  value: value,
                  minHeight: 14,
                  borderRadius: BorderRadius.circular(999),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniMetric extends StatelessWidget {
  const _MiniMetric({required this.icon, required this.label, required this.value});

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: scheme.surface.withOpacity(0.55),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: scheme.primary),
          const SizedBox(height: 8),
          Text(label, style: TextStyle(color: scheme.onSurfaceVariant, fontSize: 12)),
          const SizedBox(height: 2),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }
}

class _TaskCard extends StatelessWidget {
  const _TaskCard({
    required this.task,
    required this.onChanged,
    required this.onDeleted,
  });

  final StudyTask task;
  final ValueChanged<bool> onChanged;
  final VoidCallback onDeleted;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Dismissible(
      key: ValueKey(task.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 22),
        decoration: BoxDecoration(
          color: scheme.errorContainer,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Icon(Icons.delete_rounded, color: scheme.onErrorContainer),
      ),
      onDismissed: (_) => onDeleted(),
      child: Card(
        child: CheckboxListTile(
          value: task.done,
          onChanged: (value) => onChanged(value ?? false),
          title: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
              decoration: task.done ? TextDecoration.lineThrough : TextDecoration.none,
              color: task.done ? scheme.onSurfaceVariant : scheme.onSurface,
              fontWeight: FontWeight.w700,
            ),
            child: Text(task.title),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                Chip(
                  label: Text(task.course),
                  avatar: const Icon(Icons.menu_book_rounded, size: 16),
                  visualDensity: VisualDensity.compact,
                ),
                Chip(
                  label: Text(task.type.label),
                  avatar: Icon(task.type.icon, size: 16),
                  visualDensity: VisualDensity.compact,
                ),
                Chip(
                  label: Text('+${task.points}'),
                  avatar: const Icon(Icons.stars_rounded, size: 16),
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
          ),
          secondary: AnimatedScale(
            duration: const Duration(milliseconds: 260),
            scale: task.done ? 1.12 : 1,
            child: CircleAvatar(
              backgroundColor: task.done ? scheme.primary : scheme.surfaceContainerHighest,
              child: Icon(
                task.done ? Icons.done_rounded : Icons.circle_outlined,
                color: task.done ? scheme.onPrimary : scheme.onSurfaceVariant,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FocusPage extends StatefulWidget {
  const _FocusPage({
    required this.todayFocusMinutes,
    required this.onFocusCompleted,
    required this.onQuitEarly,
  });

  final int todayFocusMinutes;
  final ValueChanged<int> onFocusCompleted;
  final VoidCallback onQuitEarly;

  @override
  State<_FocusPage> createState() => _FocusPageState();
}

class _FocusPageState extends State<_FocusPage> {
  static const List<int> _plans = [5, 15, 25, 45];

  Timer? _timer;
  int _selectedMinutes = 25;
  int _remainingSeconds = 25 * 60;
  bool _running = false;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  double get _progress {
    final total = _selectedMinutes * 60;
    if (total == 0) return 0;
    return 1 - _remainingSeconds / total;
  }

  String get _timeText {
    final minutes = _remainingSeconds ~/ 60;
    final seconds = _remainingSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  void _selectPlan(int minutes) {
    if (_running) return;
    setState(() {
      _selectedMinutes = minutes;
      _remainingSeconds = minutes * 60;
    });
  }

  void _start() {
    if (_running) return;
    setState(() => _running = true);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds <= 1) {
        timer.cancel();
        setState(() {
          _remainingSeconds = 0;
          _running = false;
        });
        widget.onFocusCompleted(_selectedMinutes);
        _showSnack('本轮专注完成，已增加 $_selectedMinutes 分钟专注时长');
      } else {
        setState(() => _remainingSeconds--);
      }
    });
  }

  void _pause() {
    _timer?.cancel();
    setState(() => _running = false);
  }

  void _giveUp() {
    _timer?.cancel();
    widget.onQuitEarly();
    setState(() {
      _running = false;
      _remainingSeconds = _selectedMinutes * 60;
    });
    _showSnack('提前退出，本次自律分 -5');
  }

  void _showSnack(String text) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return ListView(
      padding: const EdgeInsets.all(18),
      children: [
        Text(
          '专注监督',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 6),
        Text('今天已经专注 ${widget.todayFocusMinutes} 分钟。建议每天至少 60 分钟。', style: TextStyle(color: scheme.onSurfaceVariant)),
        const SizedBox(height: 18),
        Card(
          color: scheme.secondaryContainer,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: _progress),
                  duration: const Duration(milliseconds: 300),
                  builder: (context, value, _) {
                    return SizedBox(
                      width: 220,
                      height: 220,
                      child: CustomPaint(
                        painter: RingProgressPainter(
                          progress: value,
                          color: scheme.primary,
                          backgroundColor: scheme.surface.withOpacity(0.6),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _timeText,
                                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                  fontWeight: FontWeight.w900,
                                  color: scheme.onSecondaryContainer,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(_running ? '监督中，不要摸鱼' : '准备开始', style: TextStyle(color: scheme.onSecondaryContainer)),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),
                Wrap(
                  spacing: 8,
                  children: _plans.map((minutes) {
                    return ChoiceChip(
                      label: Text('$minutes 分钟'),
                      selected: _selectedMinutes == minutes,
                      onSelected: (_) => _selectPlan(minutes),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: _running ? _pause : _start,
                        icon: Icon(_running ? Icons.pause_rounded : Icons.play_arrow_rounded),
                        label: Text(_running ? '暂停' : '开始'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _giveUp,
                        icon: const Icon(Icons.close_rounded),
                        label: const Text('放弃'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('监督规则', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
                const SizedBox(height: 10),
                const Text('1. 完成一轮专注，增加对应专注时长。\n2. 每 5 分钟专注至少增加 1 点自律分。\n3. 提前放弃会扣 5 点自律分。\n4. 今日任务全完成 + 今日专注满 60 分钟，才算今日监督成功。'),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _StatsPage extends StatelessWidget {
  const _StatsPage({
    required this.completedDates,
    required this.streak,
    required this.donePoints,
    required this.totalPoints,
    required this.doneCount,
    required this.totalCount,
    required this.todayFocusMinutes,
    required this.totalFocusMinutes,
    required this.selfDisciplineScore,
  });

  final Set<String> completedDates;
  final int streak;
  final int donePoints;
  final int totalPoints;
  final int doneCount;
  final int totalCount;
  final int todayFocusMinutes;
  final int totalFocusMinutes;
  final int selfDisciplineScore;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final cards = [
      _StatData('连续监督', '$streak 天', Icons.local_fire_department_rounded),
      _StatData('成功天数', '${completedDates.length} 天', Icons.emoji_events_rounded),
      _StatData('今日专注', '$todayFocusMinutes 分钟', Icons.timer_rounded),
      _StatData('累计专注', '$totalFocusMinutes 分钟', Icons.timeline_rounded),
      _StatData('今日任务', '$doneCount/$totalCount', Icons.task_alt_rounded),
      _StatData('自律分', '$selfDisciplineScore/100', Icons.psychology_rounded),
    ];

    return ListView(
      padding: const EdgeInsets.all(18),
      children: [
        Text(
          '学习监督统计',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 6),
        Text('统计的是本机本地数据，适合课程设计原型。', style: TextStyle(color: scheme.onSurfaceVariant)),
        const SizedBox(height: 18),
        GridView.builder(
          itemCount: cards.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.24,
          ),
          itemBuilder: (context, index) {
            final item = cards[index];
            return Card(
              color: index == 0 ? scheme.tertiaryContainer : null,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(item.icon, size: 32, color: scheme.primary),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.value, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900)),
                        Text(item.label),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 18),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('最近 14 天监督日历', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _recentDateKeys(14).map((key) {
                    final done = completedDates.contains(key);
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      width: 42,
                      height: 42,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: done ? scheme.primary : scheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        key.substring(8),
                        style: TextStyle(
                          color: done ? scheme.onPrimary : scheme.onSurfaceVariant,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  List<String> _recentDateKeys(int count) {
    final now = DateTime.now();
    return List.generate(count, (index) {
      final date = now.subtract(Duration(days: count - 1 - index));
      return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    });
  }
}

class _SettingsPage extends StatelessWidget {
  const _SettingsPage({
    required this.onToggleTheme,
    required this.onResetToday,
  });

  final VoidCallback onToggleTheme;
  final VoidCallback onResetToday;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(18),
      children: [
        Text(
          '设置',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 12),
        Card(
          child: ListTile(
            leading: const Icon(Icons.brightness_6_rounded),
            title: const Text('切换明暗主题'),
            subtitle: const Text('适合展示 Material 3 动态风格'),
            onTap: onToggleTheme,
          ),
        ),
        Card(
          child: ListTile(
            leading: const Icon(Icons.refresh_rounded),
            title: const Text('重置今日监督'),
            subtitle: const Text('清空今日任务完成状态和今日专注时长'),
            onTap: onResetToday,
          ),
        ),
        const SizedBox(height: 16),
        const Card(
          child: Padding(
            padding: EdgeInsets.all(18),
            child: Text(
              '后续可扩展功能：\n'
                  '1. 课程表导入：按星期自动生成学习任务。\n'
                  '2. 室友 / 同学监督：互相查看打卡状态。\n'
                  '3. 番茄钟白名单：专注时只允许打开学习 App。\n'
                  '4. 学习报告：生成周报，展示专注时长和完成率。\n'
                  '5. 云同步：使用 Firebase / Supabase / 后端数据库。',
            ),
          ),
        ),
      ],
    );
  }
}

class RingProgressPainter extends CustomPainter {
  RingProgressPainter({
    required this.progress,
    required this.color,
    required this.backgroundColor,
  });

  final double progress;
  final Color color;
  final Color backgroundColor;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 - 8;
    final rect = Rect.fromCircle(center: center, radius: radius);

    final basePaint = Paint()
      ..color = backgroundColor
      ..strokeWidth = 12
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final progressPaint = Paint()
      ..color = color
      ..strokeWidth = 12
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, basePaint);
    canvas.drawArc(rect, -math.pi / 2, progress * math.pi * 2, false, progressPaint);
  }

  @override
  bool shouldRepaint(covariant RingProgressPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color || oldDelegate.backgroundColor != backgroundColor;
  }
}

class _StatData {
  const _StatData(this.label, this.value, this.icon);

  final String label;
  final String value;
  final IconData icon;
}

enum StudyTaskType {
  review,
  assignment,
  coding,
  reading,
}

extension StudyTaskTypeX on StudyTaskType {
  String get label {
    return switch (this) {
      StudyTaskType.review => '复习',
      StudyTaskType.assignment => '作业',
      StudyTaskType.coding => '代码',
      StudyTaskType.reading => '阅读',
    };
  }

  IconData get icon {
    return switch (this) {
      StudyTaskType.review => Icons.auto_stories_rounded,
      StudyTaskType.assignment => Icons.edit_note_rounded,
      StudyTaskType.coding => Icons.code_rounded,
      StudyTaskType.reading => Icons.chrome_reader_mode_rounded,
    };
  }

  static StudyTaskType fromName(String? name) {
    return StudyTaskType.values.firstWhere(
          (item) => item.name == name,
      orElse: () => StudyTaskType.assignment,
    );
  }
}

class StudyTask {
  StudyTask({
    required this.id,
    required this.title,
    required this.course,
    required this.type,
    required this.points,
    this.done = false,
  });

  final String id;
  final String title;
  final String course;
  final StudyTaskType type;
  final int points;
  bool done;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'course': course,
      'type': type.name,
      'points': points,
      'done': done,
    };
  }

  factory StudyTask.fromJson(Map<String, dynamic> json) {
    return StudyTask(
      id: json['id'] as String? ?? DateTime.now().microsecondsSinceEpoch.toString(),
      title: json['title'] as String? ?? '未命名任务',
      course: json['course'] as String? ?? '其他',
      type: StudyTaskTypeX.fromName(json['type'] as String?),
      points: json['points'] as int? ?? 10,
      done: json['done'] as bool? ?? false,
    );
  }
}
