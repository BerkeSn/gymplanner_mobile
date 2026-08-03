import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_radius.dart';
import 'app_text_styles.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get light =>
      _build(Brightness.light);
  static ThemeData get dark =>
      _build(Brightness.dark);

  /// ÖNEMLİ: Bu çağrılmadan önce AppColors.setBrightness(...) ile doğru
  /// mod ayarlanmış olmalı — GymPlannerApp.build() bunu garanti eder.
  static ThemeData _build(Brightness brightness) {
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor:
          AppColors.background,
      colorScheme: ColorScheme(
        brightness: brightness,
        primary: AppColors.primary,
        onPrimary: AppColors.onPrimary,
        secondary: AppColors.secondary,
        onSecondary: AppColors.onPrimary,
        surface: AppColors.surface,
        onSurface: AppColors.onSurface,
        error: AppColors.error,
        onError: AppColors.onError,
        errorContainer: AppColors.errorContainer,
        outline: AppColors.outline,
      ),
      textTheme: TextTheme(
        headlineLarge:
            AppTextStyles.headlineLarge,
        headlineMedium:
            AppTextStyles.headlineMedium,
        bodyLarge: AppTextStyles.bodyLarge,
        bodyMedium: AppTextStyles.bodyMedium,
        labelSmall: AppTextStyles.labelSmall,
      ),
      elevatedButtonTheme:
          ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor:
                  AppColors.onPrimary,
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(
                      AppRadius.md,
                    ),
              ),
              padding: const EdgeInsets.symmetric(
                vertical: 16,
              ),
            ),
          ),
      inputDecorationTheme: InputDecorationTheme(
        filled: false,
        border: UnderlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.outlineVariant,
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.primary,
            width: 1.5,
          ),
        ),
      ),
    );
  }
}
