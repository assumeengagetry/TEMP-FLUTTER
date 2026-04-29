import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app_providers.dart';
import '../../core/utils/date_utils.dart';
import '../../models/focus_session.dart';
import 'focus_controller.dart';

class FocusPage extends ConsumerStatefulWidget {
  const FocusPage({super.key});

  @override
  ConsumerState<FocusPage> createState() => _FocusPageState();
}

class _FocusPageState extends ConsumerState<FocusPage> {
  static const List<int> _presetPlans = [5, 15, 25, 45, 60];

  Timer? _timer;
  bool _freeMode = false;
  bool _running = false;
  int _selectedMinutes = 25;
  int _remainingSeconds = 25 * 60;
  int _elapsedSeconds = 0;
  DateTime? _startedAt;
  String _selectedCourse = '通用自习';

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  double get _progress {
    final controller = ref.read(focusControllerProvider);
    if (_freeMode) {
      final target = controller.focusGoalMinutes * 60;
      if (target == 0) return 0;
      return (_elapsedSeconds / target).clamp(0, 1);
    }

    final total = _selectedMinutes * 60;
    if (total == 0) return 0;
    return 1 - _remainingSeconds / total;
  }

  String get _timeText {
    final seconds = _freeMode ? _elapsedSeconds : _remainingSeconds;
    final minutes = seconds ~/ 60;
    final remain = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remain.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(focusControllerProvider);
    final scheme = Theme.of(context).colorScheme;
    final courses = [
      '通用自习',
      ...controller.courses.where((item) => item != '通用自习'),
    ];
    if (!courses.contains(_selectedCourse)) {
      _selectedCourse = courses.first;
    }

    return ListView(
      padding: const EdgeInsets.all(18),
      children: [
        Text(
          '今日已专注 ${controller.todayFocusMinutes} 分钟，目标 ${controller.focusGoalMinutes} 分钟。',
          style: TextStyle(color: scheme.onSurfaceVariant),
        ),
        if (controller.deepFocusUnlocked) ...[
          const SizedBox(height: 12),
          Card(
            color: scheme.tertiaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(Icons.bolt_rounded, color: scheme.onTertiaryContainer),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      '已触发深度学习模式：今天连续完成了至少 2 轮番茄钟，后续完成专注将获得额外奖励。',
                      style: TextStyle(color: scheme.onTertiaryContainer),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
        const SizedBox(height: 18),
        Card(
          color: scheme.secondaryContainer,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                SizedBox(
                  width: 220,
                  height: 220,
                  child: CustomPaint(
                    painter: _RingProgressPainter(
                      progress: _progress,
                      color: scheme.primary,
                      backgroundColor: scheme.surface.withValues(alpha: 0.5),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _timeText,
                            style: Theme.of(context).textTheme.displaySmall
                                ?.copyWith(
                                  fontWeight: FontWeight.w900,
                                  color: scheme.onSecondaryContainer,
                                ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _running
                                ? (_freeMode ? '自由专注进行中' : '监督中，不要摸鱼')
                                : (_freeMode ? '准备自由专注' : '准备开始番茄钟'),
                            style: TextStyle(
                              color: scheme.onSecondaryContainer,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                DropdownButtonFormField<String>(
                  initialValue: _selectedCourse,
                  decoration: const InputDecoration(labelText: '本轮课程'),
                  items: courses
                      .map(
                        (item) => DropdownMenuItem<String>(
                          value: item,
                          child: Text(item),
                        ),
                      )
                      .toList(),
                  onChanged: _running
                      ? null
                      : (value) {
                          if (value == null) return;
                          setState(() => _selectedCourse = value);
                        },
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ChoiceChip(
                      label: const Text('固定番茄钟'),
                      selected: !_freeMode,
                      onSelected: _running
                          ? null
                          : (_) => setState(() {
                              _freeMode = false;
                              _remainingSeconds = _selectedMinutes * 60;
                            }),
                    ),
                    ChoiceChip(
                      label: const Text('自由专注'),
                      selected: _freeMode,
                      onSelected: _running
                          ? null
                          : (_) => setState(() {
                              _freeMode = true;
                              _elapsedSeconds = 0;
                            }),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (!_freeMode)
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _presetPlans.map((minutes) {
                      return ChoiceChip(
                        label: Text('$minutes 分钟'),
                        selected: _selectedMinutes == minutes,
                        onSelected: _running
                            ? null
                            : (_) => _selectPlan(minutes),
                      );
                    }).toList(),
                  ),
                if (_freeMode)
                  Text(
                    '自由专注将正计时，停止时按实际时长生成一条 Session 记录。',
                    style: TextStyle(color: scheme.onSurfaceVariant),
                  ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: _running ? _pause : _start,
                        icon: Icon(
                          _running
                              ? Icons.pause_rounded
                              : Icons.play_arrow_rounded,
                        ),
                        label: Text(_running ? '暂停' : '开始'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _freeMode
                            ? (_running ? _finishFreeFocus : null)
                            : (_running ? _giveUp : null),
                        icon: Icon(
                          _freeMode ? Icons.flag_rounded : Icons.close_rounded,
                        ),
                        label: Text(_freeMode ? '完成并记录' : '提前放弃'),
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
                Text(
                  '每日目标',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [60, 120, 180].map((minutes) {
                    return _GoalChip(minutes: minutes, controller: controller);
                  }).toList(),
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
                Text(
                  '最近专注记录',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 12),
                if (controller.focusSessions.isEmpty)
                  Text(
                    '还没有专注记录，先开始第一轮。',
                    style: TextStyle(color: scheme.onSurfaceVariant),
                  )
                else
                  ...controller.focusSessions.take(6).map((item) {
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: CircleAvatar(
                        backgroundColor: item.completed
                            ? scheme.primaryContainer
                            : scheme.errorContainer,
                        child: Icon(
                          item.completed
                              ? Icons.done_rounded
                              : Icons.close_rounded,
                          color: item.completed
                              ? scheme.onPrimaryContainer
                              : scheme.onErrorContainer,
                        ),
                      ),
                      title: Text('${item.course} · ${item.actualMinutes} 分钟'),
                      subtitle: Text(
                        '${item.mode == FocusMode.free ? '自由专注' : '番茄钟'} · '
                        '${AppDateUtils.formatDateTime(item.startedAt)}',
                      ),
                      trailing: Text(item.completed ? '完成' : '中断'),
                    );
                  }),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _selectPlan(int minutes) {
    setState(() {
      _selectedMinutes = minutes;
      _remainingSeconds = minutes * 60;
      _elapsedSeconds = 0;
    });
  }

  void _start() {
    if (_running) return;
    _startedAt ??= DateTime.now();
    setState(() => _running = true);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_freeMode) {
        setState(() => _elapsedSeconds++);
        return;
      }

      if (_remainingSeconds <= 1) {
        timer.cancel();
        _completePresetFocus();
        return;
      }
      setState(() => _remainingSeconds--);
    });
  }

  void _pause() {
    _timer?.cancel();
    setState(() => _running = false);
  }

  Future<void> _completePresetFocus() async {
    final controller = ref.read(focusControllerProvider);
    final startedAt = _startedAt ?? DateTime.now();
    final session = FocusSession(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      course: _selectedCourse,
      mode: FocusMode.preset,
      plannedMinutes: _selectedMinutes,
      actualMinutes: _selectedMinutes,
      completed: true,
      interrupted: false,
      startedAt: startedAt,
      endedAt: DateTime.now(),
    );
    _resetLocalState();
    await controller.addFocusSession(session);
    _showSnack('本轮专注完成，已记录 ${session.actualMinutes} 分钟');
  }

  Future<void> _finishFreeFocus() async {
    final controller = ref.read(focusControllerProvider);
    if (!_running) return;
    final actualMinutes = math.max(1, (_elapsedSeconds / 60).round());
    final startedAt = _startedAt ?? DateTime.now();
    _timer?.cancel();
    _resetLocalState();
    await controller.addFocusSession(
      FocusSession(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        course: _selectedCourse,
        mode: FocusMode.free,
        plannedMinutes: actualMinutes,
        actualMinutes: actualMinutes,
        completed: true,
        interrupted: false,
        startedAt: startedAt,
        endedAt: DateTime.now(),
      ),
    );
    _showSnack('自由专注结束，已记录 $actualMinutes 分钟');
  }

  Future<void> _giveUp() async {
    final controller = ref.read(focusControllerProvider);
    if (!_running) return;
    final startedAt = _startedAt ?? DateTime.now();
    _timer?.cancel();
    _resetLocalState();
    await controller.addFocusSession(
      FocusSession(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        course: _selectedCourse,
        mode: FocusMode.preset,
        plannedMinutes: _selectedMinutes,
        actualMinutes: 0,
        completed: false,
        interrupted: true,
        startedAt: startedAt,
        endedAt: DateTime.now(),
      ),
    );
    _showSnack('已放弃本轮专注，自律分 -5');
  }

  void _resetLocalState() {
    setState(() {
      _running = false;
      _elapsedSeconds = 0;
      _remainingSeconds = _selectedMinutes * 60;
      _startedAt = null;
    });
  }

  void _showSnack(String text) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }
}

class _GoalChip extends StatelessWidget {
  const _GoalChip({required this.minutes, required this.controller});

  final int minutes;
  final FocusController controller;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text('$minutes 分钟'),
      selected: controller.focusGoalMinutes == minutes,
      onSelected: (_) => controller.setFocusGoal(minutes),
    );
  }
}

class _RingProgressPainter extends CustomPainter {
  _RingProgressPainter({
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
      ..strokeWidth = 14
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final progressPaint = Paint()
      ..color = color
      ..strokeWidth = 14
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, basePaint);
    canvas.drawArc(
      rect,
      -math.pi / 2,
      progress * math.pi * 2,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _RingProgressPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.color != color ||
        oldDelegate.backgroundColor != backgroundColor;
  }
}
