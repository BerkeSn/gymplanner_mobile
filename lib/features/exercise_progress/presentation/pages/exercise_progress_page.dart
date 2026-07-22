import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymplanner_mobile/features/exercise_progress/presentation/controllers/exercise_progress_controller.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/exercise_placeholder_thumbnail.dart';
import '../../../../core/widgets/simple_line_chart.dart';
import '../../../exercise/domain/entities/exercise_entity.dart';
import '../../domain/entities/exercise_progress_entry.dart';

class ExerciseProgressPage
    extends ConsumerWidget {
  final ExerciseEntity exercise;

  const ExerciseProgressPage({
    super.key,
    required this.exercise,
  });

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final asyncHistory = ref.watch(
      exerciseProgressProvider(exercise.id),
    );

    return Scaffold(
      appBar: AppBar(title: Text(exercise.name)),
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
          if (history.isEmpty) {
            return _EmptyState(
              exercise: exercise,
            );
          }
          return _ProgressContent(
            exercise: exercise,
            history: history,
          );
        },
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final ExerciseEntity exercise;
  const _EmptyState({required this.exercise});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(
          AppSpacing.xl,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ExercisePlaceholderThumbnail(
              imageUrl: exercise.imageUrl,
              muscleGroupName:
                  exercise.muscleGroupName,
              size: 96,
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Bu hareket için henüz antrenman kaydı yok.',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyLarge,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Bir antrenman oturumunda bu hareketi tamamladığında ilerlemen burada görünecek.',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}

class _ProgressContent extends StatelessWidget {
  final ExerciseEntity exercise;
  final List<ExerciseProgressEntry> history;

  const _ProgressContent({
    required this.exercise,
    required this.history,
  });

  double get _averageVolume =>
      history
          .map((e) => e.totalVolume)
          .reduce((a, b) => a + b) /
      history.length;

  /// history zaten tarihe göre ARTAN sıralı geliyor (backend garantisi),
  /// bu yüzden en yüksek 1RM'e sahip kaydı bulmak yeterli — o kayıt "PR".
  ExerciseProgressEntry get _personalRecord =>
      history.reduce(
        (a, b) => a.estimated1RM > b.estimated1RM
            ? a
            : b,
      );

  /// İlk kayda göre son kaydın yüzdesel değişimi (hacim bazlı).
  double get _trendPercent {
    final first = history.first.totalVolume;
    final last = history.last.totalVolume;
    if (first == 0) return 0;
    return ((last - first) / first) * 100;
  }

  @override
  Widget build(BuildContext context) {
    final trend = _trendPercent;
    final isPositiveTrend = trend >= 0;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(
        AppSpacing.containerMargin,
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ExercisePlaceholderThumbnail(
                imageUrl: exercise.imageUrl,
                muscleGroupName:
                    exercise.muscleGroupName,
                size: 56,
              ),
              const SizedBox(
                width: AppSpacing.md,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      exercise.name,
                      style: AppTextStyles
                          .headlineMedium,
                    ),
                    Text(
                      '${exercise.muscleGroupName} • ${exercise.equipmentName}',
                      style: AppTextStyles
                          .bodyMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),

          // Bento grid: sol taraf metrikler, sağ taraf trend grafiği.
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
                Text(
                  'ORTALAMA HACİM',
                  style: AppTextStyles.labelSmall,
                ),
                const SizedBox(
                  height: AppSpacing.xs,
                ),
                Row(
                  crossAxisAlignment:
                      CrossAxisAlignment.baseline,
                  textBaseline:
                      TextBaseline.alphabetic,
                  children: [
                    Text(
                      _averageVolume
                          .toStringAsFixed(0),
                      style: AppTextStyles
                          .headlineLarge,
                    ),
                    const SizedBox(
                      width: AppSpacing.xs,
                    ),
                    Text(
                      'kg',
                      style: AppTextStyles
                          .bodyMedium,
                    ),
                  ],
                ),
                const SizedBox(
                  height: AppSpacing.xs,
                ),
                Row(
                  children: [
                    Icon(
                      isPositiveTrend
                          ? Icons.trending_up
                          : Icons.trending_down,
                      size: 16,
                      color: isPositiveTrend
                          ? AppColors.primary
                          : AppColors.error,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${isPositiveTrend ? '+' : ''}${trend.toStringAsFixed(1)}% ilk kayda göre',
                      style: AppTextStyles
                          .bodyMedium
                          .copyWith(
                            color: isPositiveTrend
                                ? AppColors
                                      .primary
                                : AppColors.error,
                          ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: AppSpacing.lg,
                ),
                SimpleLineChart(
                  values: history
                      .map((e) => e.totalVolume)
                      .toList(),
                  height: 140,
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

          // En yeni oturum en üstte gösterilsin diye ters çeviriyoruz —
          // backend artan sırayla veriyor ama kullanıcı en son antrenmanını
          // en üstte görmeyi bekler.
          ...history.reversed.map((entry) {
            final isPr =
                entry.workoutLogId ==
                _personalRecord.workoutLogId;
            return _HistoryEntryTile(
              entry: entry,
              isPersonalRecord: isPr,
            );
          }),
        ],
      ),
    );
  }
}

class _HistoryEntryTile extends StatelessWidget {
  final ExerciseProgressEntry entry;
  final bool isPersonalRecord;

  const _HistoryEntryTile({
    required this.entry,
    required this.isPersonalRecord,
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
            SizedBox(
              width: 48,
              child: Text(
                _formatDate(entry.date),
                style: AppTextStyles.labelSmall,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
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
                            color:
                                AppColors.primary,
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
                    style:
                        AppTextStyles.bodyMedium,
                  ),
                ],
              ),
            ),
            Text(
              '${entry.totalVolume.toStringAsFixed(0)} kg',
              style: AppTextStyles.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
