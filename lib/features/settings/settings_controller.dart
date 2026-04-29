import 'package:flutter/material.dart';

import '../../app_controller.dart';

class SettingsController {
  const SettingsController({required this.state, required this.actions});

  final StudyAppState state;
  final StudyAppNotifier actions;

  ThemeMode get themeMode => state.themeMode;
  Future<void> cycleThemeMode() => actions.cycleThemeMode();
  Future<void> resetToday() => actions.resetToday();
  Future<void> clearAllData() => actions.clearAllData();
}
