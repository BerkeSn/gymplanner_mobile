import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/app_localizations.dart';
import '../locale/locale_controller.dart';
import '../theme/app_spacing.dart';

class LanguageSelectorSheet
    extends ConsumerWidget {
  const LanguageSelectorSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (_) =>
          const LanguageSelectorSheet(),
    );
  }

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final l10n = AppLocalizations.of(context);
    final currentLocale =
        ref
            .watch(localeControllerProvider)
            .valueOrNull ??
        const Locale('tr');
    final controller = ref.read(
      localeControllerProvider.notifier,
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
              l10n.languageMenuItem,
              style: Theme.of(
                context,
              ).textTheme.headlineMedium,
            ),
            const SizedBox(height: AppSpacing.md),
            RadioListTile<String>(
              title: Text(
                l10n.turkishLanguageOption,
              ),
              value: 'tr',
              groupValue:
                  currentLocale.languageCode,
              onChanged: (code) {
                if (code != null)
                  controller.setLocale(
                    Locale(code),
                  );
                Navigator.of(context).pop();
              },
            ),
            RadioListTile<String>(
              title: Text(
                l10n.englishLanguageOption,
              ),
              value: 'en',
              groupValue:
                  currentLocale.languageCode,
              onChanged: (code) {
                if (code != null)
                  controller.setLocale(
                    Locale(code),
                  );
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}
