import 'package:flutter/material.dart';

/// İki ayrı palet: Light ve Dark. AppColors sınıfı, aktif tema moduna göre
/// doğru paletten okuyan getter'lar sunar — syntax (AppColors.primary)
/// hiç değişmez, mevcut ~20 ekranın tek satırına bile dokunmamıza gerek yok.
class _LightPalette {
  static const primary = Color(0xFF3366CC);
  static const onPrimary = Color(0xFFFFFFFF);
  static const primaryContainer = Color(
    0xFF3366CC,
  );
  static const onPrimaryContainer = Color(
    0xFFE7EBFF,
  );
  static const secondary = Color(0xFF5A5F63);
  static const tertiary = Color(0xFF6D5E00);
  static const tertiaryContainer = Color(
    0xFFBFAB49,
  );
  static const background = Color(0xFFFAF9FA);
  static const surface = Color(0xFFFAF9FA);
  static const surfaceContainer = Color(
    0xFFEFEDEE,
  );
  static const surfaceContainerLow = Color(
    0xFFF5F3F4,
  );
  static const surfaceContainerHigh = Color(
    0xFFE9E8E9,
  );
  static const surfaceContainerLowest = Color(
    0xFFFFFFFF,
  );
  static const surfaceContainerHighest = Color(
    0xFFE3E2E3,
  );
  static const onSurface = Color(0xFF1B1C1D);
  static const onSurfaceVariant = Color(
    0xFF434653,
  );
  static const outline = Color(0xFF737784);
  static const outlineVariant = Color(0xFFC3C6D5);
  static const error = Color(0xFFBA1A1A);
  static const onError = Color(0xFFFFFFFF);
  static const errorContainer = Color(0xFFFFDAD6);
}

class _DarkPalette {
  static const primary = Color(0xFF9FC2FF);
  static const onPrimary = Color(0xFF00305F);
  static const primaryContainer = Color(
    0xFF1B4788,
  );
  static const onPrimaryContainer = Color(
    0xFFD6E3FF,
  );
  static const secondary = Color(0xFFBAC3CC);
  static const tertiary = Color(0xFFE0C86B);
  static const tertiaryContainer = Color(
    0xFF544600,
  );
  static const background = Color(0xFF121316);
  static const surface = Color(0xFF121316);
  static const surfaceContainer = Color(
    0xFF1E2023,
  );
  static const surfaceContainerLow = Color(
    0xFF191B1E,
  );
  static const surfaceContainerHigh = Color(
    0xFF292B2F,
  );
  static const surfaceContainerLowest = Color(
    0xFF0C0D0F,
  );
  static const surfaceContainerHighest = Color(
    0xFF34363A,
  );
  static const onSurface = Color(0xFFE4E2E6);
  static const onSurfaceVariant = Color(
    0xFFC5C6D0,
  );
  static const outline = Color(0xFF8E9099);
  static const outlineVariant = Color(0xFF43464F);
  static const error = Color(0xFFFFB4AB);
  static const onError = Color(0xFF690005);
  static const errorContainer = Color(0xFF93000A);
}

class AppColors {
  AppColors._();

  static Brightness _brightness =
      Brightness.light;
  static bool get _isDark =>
      _brightness == Brightness.dark;

  /// GymPlannerApp.build() içinde, MaterialApp.router döndürülmeden HEMEN
  /// ÖNCE çağrılır — böylece o frame'de build edilecek tüm widget'lar
  /// doğru paleti okur.
  static void setBrightness(
    Brightness brightness,
  ) => _brightness = brightness;

  static Color get primary => _isDark
      ? _DarkPalette.primary
      : _LightPalette.primary;
  static Color get onPrimary => _isDark
      ? _DarkPalette.onPrimary
      : _LightPalette.onPrimary;
  static Color get primaryContainer => _isDark
      ? _DarkPalette.primaryContainer
      : _LightPalette.primaryContainer;
  static Color get onPrimaryContainer => _isDark
      ? _DarkPalette.onPrimaryContainer
      : _LightPalette.onPrimaryContainer;
  static Color get secondary => _isDark
      ? _DarkPalette.secondary
      : _LightPalette.secondary;
  static Color get tertiary => _isDark
      ? _DarkPalette.tertiary
      : _LightPalette.tertiary;
  static Color get tertiaryContainer => _isDark
      ? _DarkPalette.tertiaryContainer
      : _LightPalette.tertiaryContainer;
  static Color get background => _isDark
      ? _DarkPalette.background
      : _LightPalette.background;
  static Color get surface => _isDark
      ? _DarkPalette.surface
      : _LightPalette.surface;
  static Color get surfaceContainer => _isDark
      ? _DarkPalette.surfaceContainer
      : _LightPalette.surfaceContainer;
  static Color get surfaceContainerLow => _isDark
      ? _DarkPalette.surfaceContainerLow
      : _LightPalette.surfaceContainerLow;
  static Color get surfaceContainerHigh => _isDark
      ? _DarkPalette.surfaceContainerHigh
      : _LightPalette.surfaceContainerHigh;
  static Color get surfaceContainerLowest =>
      _isDark
      ? _DarkPalette.surfaceContainerLowest
      : _LightPalette.surfaceContainerLowest;
  static Color get surfaceContainerHighest =>
      _isDark
      ? _DarkPalette.surfaceContainerHighest
      : _LightPalette.surfaceContainerHighest;
  static Color get onSurface => _isDark
      ? _DarkPalette.onSurface
      : _LightPalette.onSurface;
  static Color get onSurfaceVariant => _isDark
      ? _DarkPalette.onSurfaceVariant
      : _LightPalette.onSurfaceVariant;
  static Color get outline => _isDark
      ? _DarkPalette.outline
      : _LightPalette.outline;
  static Color get outlineVariant => _isDark
      ? _DarkPalette.outlineVariant
      : _LightPalette.outlineVariant;
  static Color get error => _isDark
      ? _DarkPalette.error
      : _LightPalette.error;
  static Color get onError => _isDark
      ? _DarkPalette.onError
      : _LightPalette.onError;
  static Color get errorContainer => _isDark
      ? _DarkPalette.errorContainer
      : _LightPalette.errorContainer;
}
