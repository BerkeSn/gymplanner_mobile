import 'package:flutter/material.dart';
import 'package:gymplanner_mobile/features/walk_tracking/domain/entites/walk_session_entity.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/route_path_preview.dart';
import '../../../../l10n/app_localizations.dart';

class WalkSummaryPage extends StatelessWidget {
  final WalkSessionEntity walk;
  const WalkSummaryPage({
    super.key,
    required this.walk,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final minutes = walk.durationSeconds ~/ 60;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.walkFinishedTitle),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(
          AppSpacing.containerMargin,
        ),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.stretch,
          children: [
            RoutePathPreview(
              points: walk.routePoints
                  .map(
                    (p) =>
                        (lat: p.lat, lng: p.lng),
                  )
                  .toList(),
              height: 220,
            ),
            const SizedBox(height: AppSpacing.xl),
            Text(
              l10n.greatSessionLabel,
              textAlign: TextAlign.center,
              style: AppTextStyles.headlineMedium,
            ),
            const SizedBox(height: AppSpacing.xl),
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceEvenly,
              children: [
                _SummaryMetric(
                  label: l10n.durationLabel,
                  value: '$minutes dk',
                ),
                _SummaryMetric(
                  label: l10n.distanceLabel,
                  value:
                      '${(walk.distanceMeters / 1000).toStringAsFixed(2)} km',
                ),
                _SummaryMetric(
                  label:
                      l10n.caloriesEstimateLabel,
                  value: '${walk.calories} kcal',
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
            FilledButton(
              onPressed: () => Navigator.of(
                context,
              ).popUntil((r) => r.isFirst),
              child: Text(l10n.doneButton),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryMetric extends StatelessWidget {
  final String label;
  final String value;
  const _SummaryMetric({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: AppTextStyles.headlineMedium,
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          label.toUpperCase(),
          style: AppTextStyles.labelSmall,
        ),
      ],
    );
  }
}
