// core/widgets/primary_button.dart

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;

  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    try {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          child: isLoading
              ? SizedBox(
                  height: 20,
                  width: 20,
                  child:
                      CircularProgressIndicator(
                        strokeWidth: 2,
                        color:
                            AppColors.onPrimary,
                      ),
                )
              : Text(label),
        ),
      );
    } catch (error, stackTrace) {
      debugPrint(
        '[PrimaryButton - build]: $error\n$stackTrace',
      );
      return const SizedBox.shrink();
    }
  }
}
