import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymplanner_mobile/features/walk_tracking/presentation/controller/walk_history_controller.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../l10n/app_localizations.dart';

class WalkHistoryPage extends ConsumerWidget {
  const WalkHistoryPage({super.key});

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final l10n = AppLocalizations.of(context);
    final asyncState = ref.watch(
      walkHistoryControllerProvider,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.walkHistoryTitle),
      ),
      body: asyncState.when(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, _) =>
            Center(child: Text('$error')),
        data: (walks) {
          if (walks.isEmpty) {
            return Center(
              child: Text(l10n.noWalksYet),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(
              AppSpacing.containerMargin,
            ),
            itemCount: walks.length,
            separatorBuilder: (_, __) =>
                const SizedBox(
                  height: AppSpacing.sm,
                ),
            itemBuilder: (context, index) {
              final walk = walks[index];
              return Container(
                padding: const EdgeInsets.all(
                  AppSpacing.md,
                ),
                decoration: BoxDecoration(
                  color: AppColors
                      .surfaceContainerLowest,
                  borderRadius:
                      BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors
                        .outlineVariant
                        .withValues(alpha: 0.15),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,
                        children: [
                          Text(
                            '${walk.startTime.day}/${walk.startTime.month}/${walk.startTime.year}',
                            style: AppTextStyles
                                .labelSmall,
                          ),
                          Text(
                            '${(walk.distanceMeters / 1000).toStringAsFixed(2)} km',
                            style: AppTextStyles
                                .bodyLarge,
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '${walk.steps} ${l10n.stepsLabel}',
                      style: AppTextStyles
                          .bodyMedium,
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
