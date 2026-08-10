// features/workout_log/presentation/pages/workout_session_history_page.dart (yeni dosya)

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymplanner_mobile/core/error/result.dart';
import 'package:gymplanner_mobile/features/workout_log/domain/entites/logged_set_entity.dart';
import 'package:gymplanner_mobile/features/workout_log/domain/entites/workout_log_entity.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/exercise_placeholder_thumbnail.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../exercise_progress/presentation/pages/exercise_progress_page.dart';
import '../providers/workout_log_providers.dart';

/// Takvimde GEÇMİŞ bir gün seçildiğinde açılır — o güne ait gerçekten
/// loglanmış set verisini SALT OKUNUR gösterir. Yeni set eklenemez.
class WorkoutSessionHistoryPage
    extends ConsumerWidget {
  final int routineId;
  final DateTime date;

  const WorkoutSessionHistoryPage({
    super.key,
    required this.routineId,
    required this.date,
  });

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final l10n = AppLocalizations.of(context);
    final repository = ref.watch(
      workoutLogRepositoryProvider,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${date.day}/${date.month}/${date.year}',
        ),
      ),
      body: FutureBuilder(
        future: repository.getWorkoutLogs(),
        builder: (context, snapshot) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          final logs =
              snapshot.data?.valueOrNull ??
              <WorkoutLogEntity>[];
          final match = logs
              .where(
                (log) =>
                    log.workoutRoutineId ==
                        routineId &&
                    log.date.year == date.year &&
                    log.date.month ==
                        date.month &&
                    log.date.day == date.day,
              )
              .firstOrNull;

          if (match == null ||
              match.sets.isEmpty) {
            return Center(
              child: Text(
                l10n.noWorkoutLoggedForDay,
              ),
            );
          }

          final byExercise =
              <int, List<LoggedSetEntity>>{};
          for (final s in match.sets) {
            byExercise
                .putIfAbsent(
                  s.exerciseId,
                  () => [],
                )
                .add(s);
          }

          return ListView(
            padding: const EdgeInsets.all(
              AppSpacing.containerMargin,
            ),
            children: byExercise.entries.map((
              entry,
            ) {
              final sets = entry.value;
              final name =
                  sets.first.exerciseName ??
                  'Hareket';
              final imageUrl =
                  sets.first.exerciseImageUrl;
              return Padding(
                padding: const EdgeInsets.only(
                  bottom: AppSpacing.md,
                ),
                child: Container(
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
                          .withValues(
                            alpha: 0.15,
                          ),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () =>
                            Navigator.of(
                              context,
                            ).push(
                              MaterialPageRoute(
                                builder: (_) =>
                                    ExerciseProgressPage(
                                      exerciseId:
                                          entry
                                              .key,
                                      exerciseName:
                                          name,
                                      exerciseImageUrl:
                                          imageUrl,
                                    ),
                              ),
                            ),
                        child: Row(
                          children: [
                            ExercisePlaceholderThumbnail(
                              imageUrl: imageUrl,
                              muscleGroupName:
                                  name,
                              size: 44,
                            ),
                            const SizedBox(
                              width:
                                  AppSpacing.md,
                            ),
                            Expanded(
                              child: Text(
                                name,
                                style: AppTextStyles
                                    .headlineMedium,
                              ),
                            ),
                            Icon(
                              Icons.chevron_right,
                              color: AppColors
                                  .outline,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: AppSpacing.sm,
                      ),
                      ...sets.map(
                        (s) => Padding(
                          padding:
                              const EdgeInsets.only(
                                top:
                                    AppSpacing.xs,
                              ),
                          child: Row(
                            children: [
                              Text(
                                'SET ${s.setNumber}',
                                style: AppTextStyles
                                    .labelSmall,
                              ),
                              const Spacer(),
                              Text(
                                '${s.weight} kg × ${s.reps}',
                                style:
                                    AppTextStyles
                                        .bodyLarge,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
