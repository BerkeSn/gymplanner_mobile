import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../storage/app_preferences.dart';
import '../utils/app_logger.dart';

part 'theme_mode_controller.g.dart';

@Riverpod(keepAlive: true)
class ThemeModeController
    extends _$ThemeModeController {
  static const _prefsKey = 'app_theme_mode';

  @override
  FutureOr<ThemeMode> build() async {
    try {
      final prefs = await ref.watch(
        sharedPreferencesProvider.future,
      );
      final saved = prefs.getString(_prefsKey);
      switch (saved) {
        case 'dark':
          return ThemeMode.dark;
        case 'light':
          return ThemeMode.light;
        default:
          return ThemeMode.system;
      }
    } catch (error, stackTrace) {
      AppLogger.error(
        'ThemeModeController - build',
        error,
        stackTrace,
      );
      return ThemeMode.system;
    }
  }

  Future<void> setThemeMode(
    ThemeMode mode,
  ) async {
    try {
      state = AsyncData(mode);
      final prefs = await ref.read(
        sharedPreferencesProvider.future,
      );
      await prefs.setString(_prefsKey, mode.name);
    } catch (error, stackTrace) {
      AppLogger.error(
        'ThemeModeController - setThemeMode',
        error,
        stackTrace,
      );
    }
  }
}
