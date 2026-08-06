import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

/// Etiketli, kutulu dropdown — mockup'lardaki "input-premium" select
/// stilinin genel amaçlı karşılığı. Program oluşturma ve signup gibi
/// birden fazla yerde tekrar kullanılıyor.
class LabeledDropdown<T> extends StatelessWidget {
  final String label;
  final T value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;

  const LabeledDropdown({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.labelSmall,
        ),
        const SizedBox(height: AppSpacing.sm),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
          ),
          decoration: BoxDecoration(
            color:
                AppColors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(
              12,
            ),
            border: Border.all(
              color: AppColors.outlineVariant,
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<T>(
              value: value,
              isExpanded: true,
              items: items,
              onChanged: onChanged,
              style: AppTextStyles.bodyLarge,
              icon: Icon(
                Icons.expand_more,
                color: AppColors.outline,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
