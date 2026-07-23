import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../locale/locale_controller.dart';
import '../theme/app_colors.dart';

/// Uygulamanın herhangi bir AppBar'ına eklenebilecek, mevcut dili gösteren
/// ve dokununca diğerine geçen basit bir toggle. TR <-> EN.
class LanguageToggleButton
    extends ConsumerWidget {
  const LanguageToggleButton({super.key});

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final localeAsync = ref.watch(
      localeControllerProvider,
    );
    final currentCode =
        localeAsync.valueOrNull?.languageCode ??
        'tr';

    return TextButton(
      onPressed: () => ref
          .read(localeControllerProvider.notifier)
          .toggleLocale(),
      child: Text(
        currentCode.toUpperCase(),
        style: const TextStyle(
          color: AppColors.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
