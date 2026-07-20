// lib/core/theme/app_text_styles.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// Mockup'lardaki font ayrımı: başlıklar Noto Serif, gövde Inter,
/// etiketler Public Sans. Bu ayrımı burada sabitliyoruz.
class AppTextStyles {
  AppTextStyles._();

  static TextStyle get headlineLarge =>
      GoogleFonts.notoSerif(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: AppColors.onSurface,
        letterSpacing: -0.5,
      );

  static TextStyle get headlineMedium =>
      GoogleFonts.notoSerif(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: AppColors.onSurface,
      );

  static TextStyle get bodyLarge =>
      GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: AppColors.onSurface,
        height: 1.4,
      );

  static TextStyle get bodyMedium =>
      GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.onSurfaceVariant,
      );

  static TextStyle get labelSmall =>
      GoogleFonts.publicSans(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.2,
        color: AppColors.onSurfaceVariant,
      );
}
