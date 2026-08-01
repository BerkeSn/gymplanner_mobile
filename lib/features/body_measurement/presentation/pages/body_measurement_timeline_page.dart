// lib/features/body_measurement/presentation/pages/body_measurement_timeline_page.dart
// Dosyanın TAMAMINI şununla değiştir:

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymplanner_mobile/features/body_measurement/domain/entites/body_measurement_entity.dart';
import 'package:gymplanner_mobile/features/body_measurement/presentation/controller/body_measurement_controller.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/simple_line_chart.dart';
import '../../../../l10n/app_localizations.dart';

/// Artık Scaffold/AppBar/FAB İÇERMİYOR — InsightsPage'in bir sekme
/// içeriği olarak kullanılıyor. FAB, InsightsPage'in kendi Scaffold'unda.
class BodyMeasurementTimelineView
    extends ConsumerWidget {
  const BodyMeasurementTimelineView({super.key});

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final l10n = AppLocalizations.of(context);
    final asyncState = ref.watch(
      bodyMeasurementControllerProvider,
    );

    return asyncState.when(
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (error, _) =>
          Center(child: Text('$error')),
      data: (measurements) {
        if (measurements.isEmpty) {
          return Center(
            child: Text(l10n.noMeasurementsYet),
          );
        }
        final chronological = measurements
            .reversed
            .toList();

        return RefreshIndicator(
          onRefresh: () => ref
              .read(
                bodyMeasurementControllerProvider
                    .notifier,
              )
              .refresh(),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.containerMargin,
              AppSpacing.containerMargin,
              AppSpacing.containerMargin,
              96,
            ),
            children: [
              _CurrentWeightCard(
                latest: measurements.first,
              ),
              const SizedBox(
                height: AppSpacing.lg,
              ),
              Container(
                padding: const EdgeInsets.all(
                  AppSpacing.lg,
                ),
                decoration: BoxDecoration(
                  color: AppColors
                      .surfaceContainerLowest,
                  borderRadius:
                      BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors
                        .outlineVariant
                        .withValues(alpha: 0.15),
                  ),
                ),
                child: SimpleLineChart(
                  values: chronological
                      .map((m) => m.weight)
                      .toList(),
                  height: 140,
                ),
              ),
              const SizedBox(
                height: AppSpacing.xl,
              ),
              ...measurements.map(
                (m) => _MeasurementTile(
                  measurement: m,
                  onDelete: () => ref
                      .read(
                        bodyMeasurementControllerProvider
                            .notifier,
                      )
                      .deleteMeasurement(m.id),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _CurrentWeightCard extends StatelessWidget {
  final BodyMeasurementEntity latest;
  const _CurrentWeightCard({
    required this.latest,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(
        AppSpacing.lg,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Text(
            latest.weight.toStringAsFixed(1),
            style: AppTextStyles.headlineLarge,
          ),
          const SizedBox(width: AppSpacing.xs),
          Text(
            'kg',
            style: AppTextStyles.bodyMedium,
          ),
          if (latest.bodyFatPercentage !=
              null) ...[
            const Spacer(),
            Text(
              '${latest.bodyFatPercentage!.toStringAsFixed(1)}%',
              style: AppTextStyles.bodyLarge,
            ),
          ],
        ],
      ),
    );
  }
}

class _MeasurementTile extends StatelessWidget {
  final BodyMeasurementEntity measurement;
  final VoidCallback onDelete;

  const _MeasurementTile({
    required this.measurement,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
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
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    '${measurement.date.day}/${measurement.date.month}/${measurement.date.year}',
                    style:
                        AppTextStyles.labelSmall,
                  ),
                  Text(
                    '${measurement.weight} kg',
                    style:
                        AppTextStyles.bodyLarge,
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(
                Icons.delete_outline,
              ),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
