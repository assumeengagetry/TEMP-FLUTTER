import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app_providers.dart';

class AiPlanPage extends ConsumerStatefulWidget {
  const AiPlanPage({super.key});

  @override
  ConsumerState<AiPlanPage> createState() => _AiPlanPageState();
}

class _AiPlanPageState extends ConsumerState<AiPlanPage> {
  int _availableMinutes = 180;

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(aiPlanControllerProvider);
    final plan = controller.generateAiPlan(availableMinutes: _availableMinutes);
    final scheme = Theme.of(context).colorScheme;

    return ListView(
      padding: const EdgeInsets.all(18),
      children: [
        Card(
          color: scheme.primaryContainer,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'AI 今日计划',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  plan.summary,
                  style: TextStyle(color: scheme.onPrimaryContainer),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [60, 120, 180].map((minutes) {
                    return ChoiceChip(
                      label: Text('$minutes 分钟可用时间'),
                      selected: _availableMinutes == minutes,
                      onSelected: (_) =>
                          setState(() => _availableMinutes = minutes),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 18),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '推荐执行顺序',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 12),
                if (plan.blocks.isEmpty)
                  Text(
                    '当前没有待处理任务，建议先复盘本周学习并生成明日清单。',
                    style: TextStyle(color: scheme.onSurfaceVariant),
                  )
                else
                  ...plan.blocks.map((block) {
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: CircleAvatar(
                        backgroundColor: scheme.secondaryContainer,
                        child: const Icon(Icons.schedule_rounded),
                      ),
                      title: Text(block.taskLabel),
                      subtitle: Text('${block.timeLabel} · ${block.modeLabel}'),
                    );
                  }),
              ],
            ),
          ),
        ),
        const SizedBox(height: 18),
        Card(
          color: scheme.errorContainer,
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '风险提示',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: scheme.onErrorContainer,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  plan.risk,
                  style: TextStyle(color: scheme.onErrorContainer),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 18),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'AI 周报草稿',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 10),
                Text(plan.weeklyReview),
                const SizedBox(height: 12),
                Text(
                  '这个页面目前使用规则生成文案，后续可以把这里替换为 Supabase Edge Function 或大模型 API。',
                  style: TextStyle(color: scheme.onSurfaceVariant),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
