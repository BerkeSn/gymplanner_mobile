import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/exercise_placeholder_thumbnail.dart';
import '../../../../core/widgets/weekly_bar_chart.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/exercise_progress_entry.dart';
import '../controllers/exercise_progress_controller.dart';

enum _ProgressMetric { volume, pr }

class ExerciseProgressPage
    extends ConsumerStatefulWidget {
  final int exerciseId;
  final String exerciseName;
  final String? exerciseImageUrl;
  final String subtitle;

  const ExerciseProgressPage({
    super.key,
    required this.exerciseId,
    required this.exerciseName,
    this.exerciseImageUrl,
    this.subtitle = '—',
  });

  @override
  ConsumerState<ExerciseProgressPage>
  createState() => _ExerciseProgressPageState();
}

class _ExerciseProgressPageState
    extends ConsumerState<ExerciseProgressPage> {
  _ProgressMetric _metric =
      _ProgressMetric.volume;

  /// Pazartesi başlangıçlı haftaya göre gruplar. Hacimde HAFTALIK TOPLAM,
  /// PR'da HAFTALIK EN YÜKSEK estimated1RM kullanılır.
  List<({String label, double value})>
  _groupByWeek(
    List<ExerciseProgressEntry> history,
  ) {
    final buckets =
        <DateTime, List<ExerciseProgressEntry>>{};
    for (final entry in history) {
      final weekStart = entry.date.subtract(
        Duration(days: entry.date.weekday - 1),
      );
      final key = DateTime(
        weekStart.year,
        weekStart.month,
        weekStart.day,
      );
      buckets
          .putIfAbsent(key, () => [])
          .add(entry);
    }
    final sortedKeys = buckets.keys.toList()
      ..sort();
    return sortedKeys.map((weekStart) {
      final entries = buckets[weekStart]!;
      final value =
          _metric == _ProgressMetric.volume
          ? entries.fold<double>(
              0,
              (sum, e) => sum + e.totalVolume,
            )
          : entries
                .map((e) => e.estimated1RM)
                .reduce((a, b) => a > b ? a : b);
      return (
        label:
            '${weekStart.day}/${weekStart.month}',
        value: value,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final asyncHistory = ref.watch(
      exerciseProgressProvider(widget.exerciseId),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.exerciseName),
      ),
      body: asyncHistory.when(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(
              AppSpacing.lg,
            ),
            child: Text('Veri alınamadı: $error'),
          ),
        ),
        data: (history) {
          if (history.isEmpty)
            return _buildEmpty(context);
          return _buildContent(context, history);
        },
      ),
    );
  }

  Widget _buildEmpty(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(
        AppSpacing.containerMargin,
      ),
      child: Column(
        children: [
          ExercisePlaceholderHero(
            imageUrl: widget.exerciseImageUrl,
            muscleGroupName: widget.exerciseName,
            height: 220,
          ),
          const SizedBox(height: AppSpacing.xl),
          ExercisePlaceholderThumbnail(
            imageUrl: widget.exerciseImageUrl,
            muscleGroupName: widget.exerciseName,
            size: 64,
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Bu hareket için henüz antrenman kaydı yok.',
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyLarge,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            l10n.noPreviousDataLabel,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMedium,
          ),
        ],
      ),
    );
  }

  void _openWeekSheet(
    List<ExerciseProgressEntry> history,
    ExerciseProgressEntry tapped,
  ) {
    final weekStart = tapped.date.subtract(
      Duration(days: tapped.date.weekday - 1),
    );
    final weekEnd = weekStart.add(
      const Duration(days: 6),
    );
    final weekEntries = history
        .where(
          (e) =>
              !e.date.isBefore(weekStart) &&
              !e.date.isAfter(weekEnd),
        )
        .toList();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        final l10n = AppLocalizations.of(
          context,
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
                  l10n.weeklyRecordsTitle,
                  style: AppTextStyles
                      .headlineMedium,
                ),
                const SizedBox(
                  height: AppSpacing.xs,
                ),
                Text(
                  '${weekStart.day}/${weekStart.month} - ${weekEnd.day}/${weekEnd.month}',
                  style: AppTextStyles.bodyMedium,
                ),
                const SizedBox(
                  height: AppSpacing.md,
                ),
                ...weekEntries.map(
                  (entry) => Padding(
                    padding:
                        const EdgeInsets.only(
                          bottom: AppSpacing.sm,
                        ),
                    child: Container(
                      padding:
                          const EdgeInsets.all(
                            AppSpacing.md,
                          ),
                      decoration: BoxDecoration(
                        color: AppColors
                            .surfaceContainerLow,
                        borderRadius:
                            BorderRadius.circular(
                              12,
                            ),
                      ),
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,
                        children: [
                          Text(
                            '${entry.date.day}/${entry.date.month}/${entry.date.year}',
                            style: AppTextStyles
                                .labelSmall,
                          ),
                          const SizedBox(
                            height: AppSpacing.xs,
                          ),
                          ...entry.sets.map(
                            (s) => Text(
                              'Set ${s.setNumber}: ${s.weight}kg × ${s.reps}',
                              style: AppTextStyles
                                  .bodyMedium,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildContent(
    BuildContext context,
    List<ExerciseProgressEntry> history,
  ) {
    final l10n = AppLocalizations.of(context);
    final personalRecord = history.reduce(
      (a, b) =>
          a.estimated1RM > b.estimated1RM ? a : b,
    );
    final weeklyData = _groupByWeek(history);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(
        AppSpacing.containerMargin,
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          ExercisePlaceholderHero(
            imageUrl: widget.exerciseImageUrl,
            muscleGroupName: widget.exerciseName,
            height: 220,
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            widget.exerciseName,
            style: AppTextStyles.headlineMedium,
          ),
          Text(
            widget.subtitle,
            style: AppTextStyles.bodyMedium,
          ),
          const SizedBox(height: AppSpacing.xl),

          Container(
            padding: const EdgeInsets.all(
              AppSpacing.lg,
            ),
            decoration: BoxDecoration(
              color:
                  AppColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(
                16,
              ),
            ),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                SegmentedButton<_ProgressMetric>(
                  segments: [
                    ButtonSegment(
                      value:
                          _ProgressMetric.volume,
                      label: Text(
                        l10n.volumeMetricLabel,
                      ),
                    ),
                    ButtonSegment(
                      value: _ProgressMetric.pr,
                      label: Text(
                        l10n.prMetricLabel,
                      ),
                    ),
                  ],
                  selected: {_metric},
                  onSelectionChanged:
                      (selected) => setState(
                        () => _metric =
                            selected.first,
                      ),
                ),
                const SizedBox(
                  height: AppSpacing.lg,
                ),
                WeeklyBarChart(
                  weeks: weeklyData,
                  height: 160,
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.xl),
          Text(
            'Oturum Arşivi',
            style: AppTextStyles.headlineMedium,
          ),
          const SizedBox(height: AppSpacing.md),
          ...history.reversed.map(
            (entry) => _HistoryEntryTile(
              entry: entry,
              isPersonalRecord:
                  entry.workoutLogId ==
                  personalRecord.workoutLogId,
              onTap: () =>
                  _openWeekSheet(history, entry),
            ),
          ),
        ],
      ),
    );
  }
}

class _HistoryEntryTile extends StatelessWidget {
  final ExerciseProgressEntry entry;
  final bool isPersonalRecord;
  final VoidCallback onTap;

  const _HistoryEntryTile({
    required this.entry,
    required this.isPersonalRecord,
    required this.onTap,
  });

  String _formatDate(DateTime date) {
    const months = [
      'Oca',
      'Şub',
      'Mar',
      'Nis',
      'May',
      'Haz',
      'Tem',
      'Ağu',
      'Eyl',
      'Eki',
      'Kas',
      'Ara',
    ];
    return '${date.day} ${months[date.month - 1]}';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: AppSpacing.sm,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(
            AppSpacing.md,
          ),
          decoration: BoxDecoration(
            color:
                AppColors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(
              12,
            ),
            border: Border.all(
              color: AppColors.outlineVariant
                  .withValues(alpha: 0.15),
            ),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 48,
                child: Text(
                  _formatDate(entry.date),
                  style: AppTextStyles.labelSmall,
                ),
              ),
              const SizedBox(
                width: AppSpacing.sm,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          '${entry.maxWeight.toStringAsFixed(1)} kg',
                          style: AppTextStyles
                              .bodyLarge,
                        ),
                        if (isPersonalRecord) ...[
                          const SizedBox(
                            width: AppSpacing.xs,
                          ),
                          Container(
                            padding:
                                const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 1,
                                ),
                            decoration: BoxDecoration(
                              color: AppColors
                                  .primary,
                              borderRadius:
                                  BorderRadius.circular(
                                    4,
                                  ),
                            ),
                            child: Text(
                              'PR',
                              style: AppTextStyles
                                  .labelSmall
                                  .copyWith(
                                    color: AppColors
                                        .onPrimary,
                                    fontSize: 9,
                                  ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    Text(
                      '${entry.totalSets} set • ~${entry.estimated1RM.toStringAsFixed(1)} kg 1RM',
                      style: AppTextStyles
                          .bodyMedium,
                    ),
                  ],
                ),
              ),
              Text(
                '${entry.totalVolume.toStringAsFixed(0)} kg',
                style: AppTextStyles.bodyMedium,
              ),
              Icon(
                Icons.chevron_right,
                color: AppColors.outline,
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
