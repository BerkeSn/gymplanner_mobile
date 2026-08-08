import 'package:flutter/material.dart';
import 'package:gymplanner_mobile/features/nutrition/domain/entites/meal_entry_entity.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../l10n/app_localizations.dart';

/// Beslenme sekmesi VE Dashboard'daki öğün listesi tarafından paylaşılır —
/// tek kaynaktan yönetilir, biri değişince ikisi senkron kalır.
class MealTile extends StatelessWidget {
  final MealEntryEntity meal;
  final VoidCallback? onDelete;

  const MealTile({
    super.key,
    required this.meal,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.only(
        bottom: AppSpacing.sm,
      ),
      child: Container(
        padding: const EdgeInsets.all(
          AppSpacing.md,
        ),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.outlineVariant
                .withValues(alpha: 0.15),
          ),
        ),
        child: Row(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            // Fotoğraf Faz 7'de buraya gelecek — şimdilik ikon placeholder.
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors
                    .surfaceContainerHigh,
                borderRadius:
                    BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.restaurant,
                color: AppColors.outline,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    meal.name,
                    style:
                        AppTextStyles.bodyLarge,
                  ),
                  if (meal.servingWeight !=
                      null) ...[
                    const SizedBox(height: 2),
                    Text(
                      '${meal.servingWeight!.toStringAsFixed(0)} g',
                      style: AppTextStyles
                          .bodyMedium,
                    ),
                  ],
                  const SizedBox(
                    height: AppSpacing.xs,
                  ),
                  Wrap(
                    spacing: AppSpacing.sm,
                    children: [
                      _MacroChip(
                        label: l10n.proteinLabel,
                        value: meal.protein,
                      ),
                      _MacroChip(
                        label: l10n.carbsLabel,
                        value: meal.carbs,
                      ),
                      _MacroChip(
                        label: l10n.fatsLabel,
                        value: meal.fats,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment:
                  CrossAxisAlignment.end,
              children: [
                Text(
                  '${meal.calories} kcal',
                  style: AppTextStyles.bodyLarge,
                ),
                if (onDelete != null)
                  IconButton(
                    icon: const Icon(
                      Icons.delete_outline,
                      size: 20,
                    ),
                    onPressed: onDelete,
                    padding: EdgeInsets.zero,
                    constraints:
                        const BoxConstraints(),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MacroChip extends StatelessWidget {
  final String label;
  final double value;
  const _MacroChip({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 6,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        '${value.toStringAsFixed(0)}g $label',
        style: AppTextStyles.labelSmall.copyWith(
          fontSize: 9,
        ),
      ),
    );
  }
}
