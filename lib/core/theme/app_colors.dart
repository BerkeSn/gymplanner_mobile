// lib/core/theme/app_colors.dart
import 'package:flutter/material.dart';

/// Tek kaynak: renk paletini burada değiştirirsen tüm uygulama güncellenir.
/// Kaynak: standardized_* mockup'larındaki "Alexandria" token seti.
class AppColors {
  AppColors._();

  static const Color primary = Color(0xFF3366CC);
  static const Color onPrimary = Color(
    0xFFFFFFFF,
  );
  static const Color primaryContainer = Color(
    0xFF3366CC,
  );
  static const Color onPrimaryContainer = Color(
    0xFFE7EBFF,
  );

  static const Color secondary = Color(
    0xFF5A5F63,
  );
  static const Color tertiary = Color(0xFF6D5E00);
  static const Color tertiaryContainer = Color(
    0xFFBFAB49,
  );

  static const Color background = Color(
    0xFFFAF9FA,
  );
  static const Color surface = Color(0xFFFAF9FA);
  static const Color surfaceContainer = Color(
    0xFFEFEDEE,
  );
  static const Color surfaceContainerLow = Color(
    0xFFF5F3F4,
  );
  static const Color surfaceContainerHigh = Color(
    0xFFE9E8E9,
  );
  static const Color surfaceContainerLowest =
      Color(0xFFFFFFFF);
  static const Color surfaceContainerHighest =
      Color(0xFFE3E2E3);

  static const Color onSurface = Color(
    0xFF1B1C1D,
  );
  static const Color onSurfaceVariant = Color(
    0xFF434653,
  );
  static const Color outline = Color(0xFF737784);
  static const Color outlineVariant = Color(
    0xFFC3C6D5,
  );

  static const Color error = Color(0xFFBA1A1A);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color errorContainer = Color(
    0xFFFFDAD6,
  );
}
