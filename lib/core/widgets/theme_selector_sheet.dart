import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../theme/app_spacing.dart';
import '../theme/theme_mode_controller.dart';

class ThemeSelectorSheet extends ConsumerWidget {
  const ThemeSelectorSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (_) => const ThemeSelectorSheet(),
    );
  }

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final currentMode =
        ref
            .watch(themeModeControllerProvider)
            .valueOrNull ??
        ThemeMode.system;
    final controller = ref.read(
      themeModeControllerProvider.notifier,
    );

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(
          AppSpacing.containerMargin,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Text(
              'Görünüm',
              style: Theme.of(
                context,
              ).textTheme.headlineMedium,
            ),
            const SizedBox(height: AppSpacing.md),
            RadioListTile<ThemeMode>(
              title: const Text('Açık Tema'),
              value: ThemeMode.light,
              groupValue: currentMode,
              onChanged: (mode) {
                if (mode != null)
                  controller.setThemeMode(mode);
                Navigator.of(context).pop();
              },
            ),
            RadioListTile<ThemeMode>(
              title: const Text('Koyu Tema'),
              value: ThemeMode.dark,
              groupValue: currentMode,
              onChanged: (mode) {
                if (mode != null)
                  controller.setThemeMode(mode);
                Navigator.of(context).pop();
              },
            ),
            RadioListTile<ThemeMode>(
              title: const Text('Sistem Ayarı'),
              value: ThemeMode.system,
              groupValue: currentMode,
              onChanged: (mode) {
                if (mode != null)
                  controller.setThemeMode(mode);
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}
