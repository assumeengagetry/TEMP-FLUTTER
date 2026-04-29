import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app_providers.dart';
import 'settings_controller.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(settingsControllerProvider);
    return ListView(
      padding: const EdgeInsets.all(18),
      children: [
        Card(
          child: ListTile(
            leading: const Icon(Icons.brightness_6_rounded),
            title: const Text('切换主题模式'),
            subtitle: Text('当前模式：${_themeModeLabel(controller.themeMode)}'),
            onTap: controller.cycleThemeMode,
          ),
        ),
        Card(
          child: ListTile(
            leading: const Icon(Icons.refresh_rounded),
            title: const Text('重置今日监督'),
            subtitle: const Text('清空今日专注记录，并撤销今天完成的任务勾选'),
            onTap: controller.resetToday,
          ),
        ),
        Card(
          child: ListTile(
            leading: const Icon(Icons.delete_forever_rounded),
            title: const Text('恢复演示数据'),
            subtitle: const Text('清空本地数据，重新载入默认任务'),
            onTap: () => _confirmResetAll(context, controller),
          ),
        ),
        const SizedBox(height: 16),
        const Card(
          child: Padding(
            padding: EdgeInsets.all(18),
            child: Text(
              '当前版本已完成：\n'
              '1. 任务字段升级：类型、优先级、截止时间、预计用时、备注、完成证明。\n'
              '2. 专注升级：固定番茄钟、自由专注、每日目标、Session 历史。\n'
              '3. 统计升级：7 天趋势、课程占比、热力格、周总结。\n'
              '4. AI 页面：规则生成的今日计划与风险提示。\n'
              '5. 工程化拆分：从单文件重构为模块化目录结构。',
            ),
          ),
        ),
      ],
    );
  }

  String _themeModeLabel(ThemeMode mode) {
    return switch (mode) {
      ThemeMode.system => '跟随系统',
      ThemeMode.light => '浅色',
      ThemeMode.dark => '深色',
    };
  }

  Future<void> _confirmResetAll(
    BuildContext context,
    SettingsController controller,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('恢复演示数据'),
          content: const Text('这会清空当前本地数据并恢复默认任务，是否继续？'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('取消'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('继续'),
            ),
          ],
        );
      },
    );
    if (confirmed != true) return;
    await controller.clearAllData();
  }
}
