import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_dependencies.dart';
import 'app_providers.dart';
import 'app_storage_factory.dart';
import 'core/theme/app_theme.dart';
import 'features/ai_plan/ai_plan_page.dart';
import 'features/dashboard/dashboard_page.dart';
import 'features/focus/focus_page.dart';
import 'features/settings/settings_page.dart';
import 'features/stats/stats_page.dart';

class StudySupervisorApp extends StatelessWidget {
  const StudySupervisorApp({super.key, this.storage});

  final AppStorageFactory? storage;

  @override
  Widget build(BuildContext context) {
    final allOverrides = [
      if (storage != null)
        appStorageFactoryProvider.overrideWithValue(storage!),
    ];

    return ProviderScope(overrides: allOverrides, child: const _AppView());
  }
}

class _AppView extends ConsumerWidget {
  const _AppView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appState = ref.watch(studyAppControllerProvider);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '大学生学习监督',
      themeMode: appState.value?.themeMode ?? ThemeMode.system,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      home: appState.when(
        data: (_) => const AppShell(),
        loading: () => const _LoadingShell(),
        error: (error, stackTrace) => _ErrorShell(error: error),
      ),
    );
  }
}

class _LoadingShell extends StatelessWidget {
  const _LoadingShell();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text('正在加载学习监督数据', style: Theme.of(context).textTheme.titleMedium),
          ],
        ),
      ),
    );
  }
}

class _ErrorShell extends StatelessWidget {
  const _ErrorShell({required this.error});

  final Object error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline_rounded, size: 56),
              const SizedBox(height: 16),
              Text('学习监督数据加载失败', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              Text(
                '$error',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AppShell extends ConsumerStatefulWidget {
  const AppShell({super.key});

  @override
  ConsumerState<AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<AppShell> {
  int _pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    const pages = [
      DashboardPage(),
      FocusPage(),
      StatsPage(),
      AiPlanPage(),
      SettingsPage(),
    ];

    const titles = ['监督台', '专注', '统计', 'AI 计划', '设置'];

    return Scaffold(
      appBar: AppBar(
        title: Text(titles[_pageIndex]),
        actions: [
          IconButton(
            tooltip: '切换主题模式',
            onPressed: ref.read(settingsControllerProvider).cycleThemeMode,
            icon: const Icon(Icons.brightness_6_rounded),
          ),
        ],
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 240),
        child: KeyedSubtree(
          key: ValueKey(_pageIndex),
          child: pages[_pageIndex],
        ),
      ),
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
            icon: Icon(Icons.insights_outlined),
            selectedIcon: Icon(Icons.insights_rounded),
            label: '统计',
          ),
          NavigationDestination(
            icon: Icon(Icons.auto_awesome_outlined),
            selectedIcon: Icon(Icons.auto_awesome_rounded),
            label: 'AI 计划',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings_rounded),
            label: '设置',
          ),
        ],
      ),
    );
  }
}
