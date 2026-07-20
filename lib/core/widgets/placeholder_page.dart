import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

/// Henüz geliştirilmemiş sekmeler için tutarlı bir "yapım aşamasında"
/// ekranı. Faz 4/5/6'da her biri gerçek feature sayfasıyla değiştirilecek.
class PlaceholderPage extends StatelessWidget {
  final String title;
  final IconData icon;

  const PlaceholderPage({
    super.key,
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    try {
      return Scaffold(
        appBar: AppBar(title: Text(title)),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(
              AppSpacing.xl,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: 64,
                  color: AppColors.outlineVariant,
                ),
                const SizedBox(
                  height: AppSpacing.md,
                ),
                Text(
                  '$title bölümü ilerleyen fazlarda eklenecek.',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodyMedium,
                ),
              ],
            ),
          ),
        ),
      );
    } catch (error, stackTrace) {
      debugPrint(
        '[PlaceholderPage - build]: $error\n$stackTrace',
      );
      return Scaffold(
        body: Center(child: Text(title)),
      );
    }
  }
}
