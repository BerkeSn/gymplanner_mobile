// lib/features/workout_routine/presentation/widgets/program_detail_sheet.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/exercise_placeholder_thumbnail.dart';
import '../../../exercise/domain/entities/exercise_entity.dart';
import '../../../exercise/presentation/pages/exercise_selection_page.dart';
import '../../domain/entities/routine_exercise_entity.dart';
import '../../domain/entities/week_day.dart';
import '../../domain/entities/workout_routine_entity.dart';
import '../controllers/workout_programs_controller.dart';
import 'schedule_exercise_sheet.dart';

class ProgramDetailSheet extends ConsumerWidget {
  final WorkoutRoutineEntity routine;

  const ProgramDetailSheet({
    super.key,
    required this.routine,
  });

  static Future<void> show(
    BuildContext context,
    WorkoutRoutineEntity routine,
  ) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) =>
          ProgramDetailSheet(routine: routine),
    );
  }

  Future<void> _handleAddExercise(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final selected = await Navigator.of(context)
        .push<ExerciseEntity>(
          MaterialPageRoute(
            builder: (_) =>
                const ExerciseSelectionPage(),
          ),
        );
    if (selected != null && context.mounted) {
      await ScheduleExerciseSheet.show(
        context,
        routineId: routine.id,
        exercise: selected,
      );
    }
  }

  /// Hareketleri gün sırasına göre (Pazartesi → Pazar) gruplar.
  /// Sadece hareketi OLAN günler görünür — boş günler için başlık gösterilmez.
  Map<WeekDay, List<RoutineExerciseEntity>>
  _groupByDay(
    List<RoutineExerciseEntity> exercises,
  ) {
    final map =
        <WeekDay, List<RoutineExerciseEntity>>{};
    for (final day in WeekDay.values) {
      final dayExercises = exercises
          .where((e) => e.day == day)
          .toList();
      if (dayExercises.isNotEmpty) {
        map[day] = dayExercises;
      }
    }
    return map;
  }

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final routines = ref
        .watch(workoutProgramsControllerProvider)
        .valueOrNull;
    final current =
        routines?.firstWhere(
          (r) => r.id == routine.id,
          orElse: () => routine,
        ) ??
        routine;

    final groupedByDay = _groupByDay(
      current.routineExercises,
    );

    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Padding(
          padding: const EdgeInsets.all(
            AppSpacing.containerMargin,
          ),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(
                  bottom: AppSpacing.md,
                ),
                decoration: BoxDecoration(
                  color: AppColors.outlineVariant,
                  borderRadius:
                      BorderRadius.circular(999),
                ),
              ),
              Text(
                current.name,
                style:
                    AppTextStyles.headlineMedium,
              ),
              if (current.description != null &&
                  current
                      .description!
                      .isNotEmpty) ...[
                const SizedBox(
                  height: AppSpacing.xs,
                ),
                Text(
                  current.description!,
                  style: AppTextStyles.bodyMedium,
                ),
              ],
              const SizedBox(
                height: AppSpacing.lg,
              ),
              Expanded(
                child: groupedByDay.isEmpty
                    ? const Center(
                        child: Text(
                          'Henüz hareket eklenmedi.',
                        ),
                      )
                    : ListView(
                        controller:
                            scrollController,
                        children: groupedByDay.entries.map((
                          entry,
                        ) {
                          return _DaySection(
                            day: entry.key,
                            exercises:
                                entry.value,
                            onDelete: (id) => ref
                                .read(
                                  workoutProgramsControllerProvider
                                      .notifier,
                                )
                                .removeRoutineExercise(
                                  id,
                                ),
                          );
                        }).toList(),
                      ),
              ),
              const SizedBox(
                height: AppSpacing.md,
              ),
              FilledButton.icon(
                onPressed: () =>
                    _handleAddExercise(
                      context,
                      ref,
                    ),
                icon: const Icon(Icons.add),
                label: const Text(
                  'Egzersiz Ekle',
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Bir günün başlık rozeti + o güne ait hareket kartları.
class _DaySection extends StatelessWidget {
  final WeekDay day;
  final List<RoutineExerciseEntity> exercises;
  final ValueChanged<int> onDelete;

  const _DaySection({
    required this.day,
    required this.exercises,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: AppSpacing.lg,
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          // Gün rozeti — mockup'lardaki "day pill" stiliyle birebir.
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.xs,
            ),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(
                999,
              ),
            ),
            child: Text(
              '${day.turkishLabel.toUpperCase()} • ${exercises.length} HAREKET',
              style: AppTextStyles.labelSmall
                  .copyWith(
                    color: AppColors.onPrimary,
                  ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          ...exercises.map((routineExercise) {
            return Padding(
              padding: const EdgeInsets.only(
                bottom: AppSpacing.xs,
              ),
              child: Container(
                padding: const EdgeInsets.all(
                  AppSpacing.sm,
                ),
                decoration: BoxDecoration(
                  color: AppColors
                      .surfaceContainerLow,
                  borderRadius:
                      BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    ExercisePlaceholderThumbnail(
                      imageUrl: routineExercise
                          .exerciseImageUrl,
                      muscleGroupName:
                          routineExercise
                              .exerciseName,
                      size: 48,
                    ),
                    const SizedBox(
                      width: AppSpacing.md,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,
                        children: [
                          Text(
                            routineExercise
                                .exerciseName,
                            style: AppTextStyles
                                .bodyLarge,
                          ),
                          Text(
                            '${routineExercise.targetSets} set × ${routineExercise.targetReps} tekrar',
                            style: AppTextStyles
                                .bodyMedium,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.delete_outline,
                      ),
                      onPressed: () => onDelete(
                        routineExercise.id,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
