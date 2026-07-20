// core/widgets/app_text_field.dart

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Mockup'lardaki underline input stilini merkezileştiren tek bileşen.
/// Renk/tipografi değişirse SADECE burası güncellenir.
class AppTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool obscureText;
  final TextInputType keyboardType;
  final Widget? suffixIcon;
  final String? errorText;

  const AppTextField({
    super.key,
    required this.label,
    required this.controller,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.suffixIcon,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    try {
      return TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        style: AppTextStyles.bodyLarge,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: AppTextStyles.bodyMedium,
          suffixIcon: suffixIcon,
          errorText: errorText,
          border: const UnderlineInputBorder(
            borderSide: BorderSide(
              color: AppColors.outlineVariant,
            ),
          ),
          focusedBorder:
              const UnderlineInputBorder(
                borderSide: BorderSide(
                  color: AppColors.primary,
                  width: 1.5,
                ),
              ),
        ),
      );
    } catch (error, stackTrace) {
      debugPrint(
        '[AppTextField - build]: $error\n$stackTrace',
      );
      return const SizedBox.shrink();
    }
  }
}
