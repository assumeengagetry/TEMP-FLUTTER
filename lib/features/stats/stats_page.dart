import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app_providers.dart';
import '../../core/utils/date_utils.dart';
import '../../models/daily_stat.dart';
import 'stats_controller.dart';

class StatsPage extends ConsumerWidget {
  const StatsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(statsControllerProvider);
    final scheme = Theme.of(context).colorScheme;
    final recent = controller.recentSevenStats;
    final courseMinutes = controller.focusMinutesByCourse(days: 30);
    final weeklyFocus = recent.fold(0, (sum, item) => sum + item.focusMinutes);
    final weeklyTasks = recent.fold(
      0,
      (sum, item) => sum + item.completedTasks,
    );

    return ListView(
      padding: const EdgeInsets.all(18),
      children: [
        Text(
          '最近 7 天累计专注 $weeklyFocus 分钟，完成任务 $weeklyTasks 项。',
          style: TextStyle(color: scheme.onSurfaceVariant),
        ),
        const SizedBox(height: 18),
        _StatsSummaryGrid(controller: controller),
        const SizedBox(height: 18),
        _ChartCard(
          title: '最近 7 天专注时长',
          subtitle: '折线越高表示当日投入越多。',
          child: SizedBox(height: 220, child: _LineChart(stats: recent)),
        ),
        const SizedBox(height: 18),
        _ChartCard(
          title: '每日任务完成',
          subtitle: '柱高对应当日完成的任务数。',
          child: SizedBox(height: 220, child: _TaskBarChart(stats: recent)),
        ),
        const SizedBox(height: 18),
        _ChartCard(
          title: '课程专注占比',
          subtitle: '过去 30 天课程维度的专注累计。',
          child: Column(
            children: [
              if (courseMinutes.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    '暂无课程专注数据',
                    style: TextStyle(color: scheme.onSurfaceVariant),
                  ),
                )
              else
                ...courseMinutes.entries.map((entry) {
                  final maxMinutes = courseMinutes.values.first == 0
                      ? 1
                      : courseMinutes.values.first;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                entry.key,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            Text('${entry.value} 分钟'),
                          ],
                        ),
                        const SizedBox(height: 6),
                        LinearProgressIndicator(
                          value: entry.value / maxMinutes,
                          minHeight: 10,
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ],
                    ),
                  );
                }),
            ],
          ),
        ),
        const SizedBox(height: 18),
        _ChartCard(
          title: '连续监督热力格',
          subtitle: '成功日高亮，帮助展示打卡连续性。',
          child: _Heatmap(stats: _recentHeatmapStats(controller)),
        ),
        const SizedBox(height: 18),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '本周总结',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 10),
                Text(
                  controller.weeklyReview,
                  style: TextStyle(color: scheme.onSurfaceVariant),
                ),
                const SizedBox(height: 12),
                Text(
                  '当前自律状态：${controller.disciplineLabel}。'
                  '若想拉高趋势，优先清理逾期任务，并保持每天至少 ${controller.focusGoalMinutes} 分钟专注。',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  List<DailyStat> _recentHeatmapStats(StatsController controller) {
    final now = DateTime.now();
    return List.generate(28, (index) {
      final date = now.subtract(Duration(days: 27 - index));
      final key = AppDateUtils.dateKey(date);
      return controller.recentSevenStats.firstWhere(
        (item) => item.dateKey == key,
        orElse: () => controller.storedDailyStats.firstWhere(
          (item) => item.dateKey == key,
          orElse: () => DailyStat(
            dateKey: key,
            completedTasks: 0,
            totalTasks: 0,
            focusMinutes: 0,
            disciplineScore: 60,
            success: false,
          ),
        ),
      );
    });
  }
}

class _StatsSummaryGrid extends StatelessWidget {
  const _StatsSummaryGrid({required this.controller});

  final StatsController controller;

  @override
  Widget build(BuildContext context) {
    final items = [
      _StatData(
        '连续打卡',
        '${controller.currentStreak} 天',
        Icons.local_fire_department_rounded,
      ),
      _StatData(
        '累计专注',
        '${controller.totalFocusMinutes} 分钟',
        Icons.timer_rounded,
      ),
      _StatData(
        '今日目标',
        '${controller.todayFocusMinutes}/${controller.focusGoalMinutes}',
        Icons.track_changes_rounded,
      ),
      _StatData(
        '逾期任务',
        '${controller.overdueTaskCount}',
        Icons.warning_amber_rounded,
      ),
      _StatData(
        '完成任务',
        '${controller.doneCount}/${controller.totalCount}',
        Icons.task_alt_rounded,
      ),
      _StatData(
        '自律分',
        '${controller.selfDisciplineScore}',
        Icons.psychology_rounded,
      ),
    ];

    return GridView.builder(
      itemCount: items.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.3,
      ),
      itemBuilder: (context, index) {
        final scheme = Theme.of(context).colorScheme;
        final item = items[index];
        return Card(
          color: index == 0 ? scheme.tertiaryContainer : null,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(item.icon, color: scheme.primary, size: 30),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.value,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(item.label),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ChartCard extends StatelessWidget {
  const _ChartCard({
    required this.title,
    required this.subtitle,
    required this.child,
  });

  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 6),
            Text(subtitle, style: TextStyle(color: scheme.onSurfaceVariant)),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }
}

class _LineChart extends StatelessWidget {
  const _LineChart({required this.stats});

  final List<DailyStat> stats;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _LineChartPainter(
        values: stats.map((item) => item.focusMinutes.toDouble()).toList(),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 16, 8, 0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: stats.map((item) {
            final date =
                DateTime.tryParse('${item.dateKey} 00:00:00') ?? DateTime.now();
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  AppDateUtils.weekdayLabel(date),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _TaskBarChart extends StatelessWidget {
  const _TaskBarChart({required this.stats});

  final List<DailyStat> stats;

  @override
  Widget build(BuildContext context) {
    final maxValue = math.max(
      1,
      stats.fold(0, (sum, item) => math.max(sum, item.completedTasks)),
    );
    final scheme = Theme.of(context).colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: stats.map((item) {
        final ratio = item.completedTasks / maxValue;
        final date =
            DateTime.tryParse('${item.dateKey} 00:00:00') ?? DateTime.now();
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  '${item.completedTasks}',
                  style: Theme.of(context).textTheme.labelSmall,
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 280),
                      height: 150 * ratio,
                      decoration: BoxDecoration(
                        color: item.success
                            ? scheme.primary
                            : scheme.secondaryContainer,
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  AppDateUtils.weekdayLabel(date),
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _Heatmap extends StatelessWidget {
  const _Heatmap({required this.stats});

  final List<DailyStat> stats;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: stats.map((item) {
        final date =
            DateTime.tryParse('${item.dateKey} 00:00:00') ?? DateTime.now();
        final color = item.success
            ? scheme.primary
            : item.focusMinutes > 0
            ? scheme.secondaryContainer
            : scheme.surfaceContainerHighest;
        return Container(
          width: 42,
          height: 42,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            '${date.day}',
            style: TextStyle(
              color: item.success ? scheme.onPrimary : scheme.onSurfaceVariant,
              fontWeight: FontWeight.w700,
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _LineChartPainter extends CustomPainter {
  _LineChartPainter({required this.values});

  final List<double> values;

  @override
  void paint(Canvas canvas, Size size) {
    if (values.isEmpty) return;
    final maxValue = values.reduce(math.max);
    final chartMax = maxValue <= 0 ? 1.0 : maxValue;
    final widthStep = values.length == 1
        ? size.width
        : size.width / (values.length - 1);

    final gridPaint = Paint()
      ..color = const Color(0x335C6B78)
      ..strokeWidth = 1;
    for (var index = 1; index <= 3; index++) {
      final y = size.height * index / 4;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final path = Path();
    for (var index = 0; index < values.length; index++) {
      final x = widthStep * index;
      final y =
          size.height - (values[index] / chartMax) * (size.height - 32) - 24;
      if (index == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    final fillPath = Path.from(path)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    final fillPaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0x6616979C), Color(0x0016979C)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawPath(fillPath, fillPaint);

    final linePaint = Paint()
      ..color = const Color(0xFF16979C)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(path, linePaint);

    final dotPaint = Paint()..color = const Color(0xFF0B7285);
    for (var index = 0; index < values.length; index++) {
      final x = widthStep * index;
      final y =
          size.height - (values[index] / chartMax) * (size.height - 32) - 24;
      canvas.drawCircle(Offset(x, y), 4.5, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _LineChartPainter oldDelegate) {
    return oldDelegate.values != values;
  }
}

class _StatData {
  const _StatData(this.label, this.value, this.icon);

  final String label;
  final String value;
  final IconData icon;
}
