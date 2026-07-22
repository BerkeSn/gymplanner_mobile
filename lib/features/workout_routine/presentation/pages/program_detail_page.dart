import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymplanner_mobile/features/workout_log/presentation/pages/workout_session_page.dart';
import 'package:gymplanner_mobile/features/workout_routine/domain/entities/training_goal.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/app_logger.dart';
import '../../../../core/widgets/exercise_placeholder_thumbnail.dart';
import '../../../exercise/domain/entities/exercise_entity.dart';
import '../../../exercise/presentation/pages/exercise_selection_page.dart';
import '../../domain/entities/routine_exercise_entity.dart';
import '../../domain/entities/week_day.dart';
import '../../domain/entities/workout_routine_entity.dart';
import '../controllers/workout_programs_controller.dart';
import '../widgets/schedule_exercise_sheet.dart';

/// standardized_workout_program_schedule.html temel alınmıştır.
/// NOT: Mockup'taki süre/hacim/hafta sayısı gibi değerler backend'de
/// karşılığı olmayan UYDURMA verilerdir — burada sadece GERÇEK veriye
/// (gün sayısı, hareket sayısı, aktiflik durumu) dayalı alanlar gösterilir.
class ProgramDetailPage extends ConsumerWidget {
  final int routineId;

  const ProgramDetailPage({
    super.key,
    required this.routineId,
  });

  Map<WeekDay, List<RoutineExerciseEntity>>
  _groupByDay(
    List<RoutineExerciseEntity> exercises,
  ) {
    final map =
        <WeekDay, List<RoutineExerciseEntity>>{};
    for (final day in WeekDay.values) {
      map[day] = exercises
          .where((e) => e.day == day)
          .toList();
    }
    return map;
  }

  Future<void> _handleAddExercise(
    BuildContext context,
    WidgetRef ref,
  ) async {
    try {
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
          routineId: routineId,
          exercise: selected,
        );
      }
    } catch (error, stackTrace) {
      AppLogger.error(
        'ProgramDetailPage - _handleAddExercise',
        error,
        stackTrace,
      );
    }
  }

  Future<void> _handleToggleActive(
    BuildContext context,
    WidgetRef ref,
    WorkoutRoutineEntity routine,
  ) async {
    try {
      await ref
          .read(
            workoutProgramsControllerProvider
                .notifier,
          )
          .toggleActive(routine);
    } catch (error, stackTrace) {
      AppLogger.error(
        'ProgramDetailPage - _handleToggleActive',
        error,
        stackTrace,
      );
    }
  }

  Future<void> _handleDelete(
    BuildContext context,
    WidgetRef ref,
    int routineId,
  ) async {
    try {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Programı Sil'),
          content: const Text(
            'Bu programı silmek istediğine emin misin? Bu işlem geri alınamaz.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(
                context,
              ).pop(false),
              child: const Text('Vazgeç'),
            ),
            TextButton(
              onPressed: () =>
                  Navigator.of(context).pop(true),
              child: const Text(
                'Sil',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
          ],
        ),
      );
      if (confirmed == true) {
        await ref
            .read(
              workoutProgramsControllerProvider
                  .notifier,
            )
            .deleteProgram(routineId);
        if (context.mounted)
          Navigator.of(context).pop();
      }
    } catch (error, stackTrace) {
      AppLogger.error(
        'ProgramDetailPage - _handleDelete',
        error,
        stackTrace,
      );
    }
  }

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final routines = ref
        .watch(workoutProgramsControllerProvider)
        .valueOrNull;
    final routine = routines
        ?.where((r) => r.id == routineId)
        .firstOrNull;

    if (routine == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final groupedByDay = _groupByDay(
      routine.routineExercises,
    );
    final activeDayCount = groupedByDay.values
        .where((list) => list.isNotEmpty)
        .length;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 260,
            pinned: true,
            actions: [
              IconButton(
                icon: const Icon(
                  Icons.delete_outline,
                ),
                onPressed: () => _handleDelete(
                  context,
                  ref,
                  routine.id,
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: ExercisePlaceholderHero(
                imageUrl: null,
                muscleGroupName: routine.name,
                height: 260,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(
                AppSpacing.containerMargin,
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _StatusBadge(
                        isActive:
                            routine.isActive,
                      ),
                      const SizedBox(
                        width: AppSpacing.sm,
                      ),
                      _CountBadge(
                        icon:
                            Icons.fitness_center,
                        label:
                            '${routine.routineExercises.length} hareket',
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: AppSpacing.md,
                  ),
                  Text(
                    routine.name,
                    style: AppTextStyles
                        .headlineLarge,
                  ),
                  if (routine.description !=
                          null &&
                      routine
                          .description!
                          .isNotEmpty) ...[
                    const SizedBox(
                      height: AppSpacing.sm,
                    ),
                    Text(
                      routine.description!,
                      style:
                          AppTextStyles.bodyLarge,
                    ),
                  ],
                  const SizedBox(
                    height: AppSpacing.lg,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: () =>
                          _handleToggleActive(
                            context,
                            ref,
                            routine,
                          ),
                      icon: Icon(
                        routine.isActive
                            ? Icons.check_circle
                            : Icons.play_arrow,
                      ),
                      label: Text(
                        routine.isActive
                            ? 'Aktif Program'
                            : 'Bu Programı Başlat',
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: AppSpacing.xl,
                  ),
                  Text(
                    'Haftalık Program',
                    style: AppTextStyles
                        .headlineMedium,
                  ),
                  const SizedBox(
                    height: AppSpacing.md,
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(
              horizontal:
                  AppSpacing.containerMargin,
            ),
            sliver: SliverList.list(
              children: WeekDay.values.map((day) {
                final exercises =
                    groupedByDay[day] ?? [];
                return Padding(
                  padding: const EdgeInsets.only(
                    bottom: AppSpacing.md,
                  ),
                  child: exercises.isEmpty
                      ? _RestDayCard(day: day)
                      : _ActiveDayCard(
                          day: day,
                          exercises: exercises,
                          routineId: routine
                              .id, // ⬅️ YENİ
                          onDelete: (id) => ref
                              .read(
                                workoutProgramsControllerProvider
                                    .notifier,
                              )
                              .removeRoutineExercise(
                                id,
                              ),
                        ),
                );
              }).toList(),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(
                AppSpacing.containerMargin,
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
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
                  const SizedBox(
                    height: AppSpacing.xl,
                  ),
                  // Program Özeti
                  Text(
                    'Program Özeti',
                    style: AppTextStyles
                        .headlineMedium,
                  ),
                  const SizedBox(
                    height: AppSpacing.md,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: _BioCell(
                          label: 'Hedef Sıklık',
                          value:
                              '${routine.daysPerWeek} Gün / Hafta',
                        ),
                      ),
                      const SizedBox(
                        width: AppSpacing.sm,
                      ),
                      Expanded(
                        child: _BioCell(
                          label:
                              'Antrenman Hedefi',
                          value: routine
                              .trainingGoal
                              .turkishLabel,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: AppSpacing.sm,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: _BioCell(
                          label: 'Planlanmış Gün',
                          value:
                              '$activeDayCount Gün',
                        ),
                      ),
                      const SizedBox(
                        width: AppSpacing.sm,
                      ),
                      Expanded(
                        child: _BioCell(
                          label: 'Toplam Hareket',
                          value:
                              '${routine.routineExercises.length}',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: AppSpacing.xl,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final bool isActive;
  const _StatusBadge({required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: isActive
            ? AppColors.primary.withValues(
                alpha: 0.12,
              )
            : AppColors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        isActive ? 'AKTİF' : 'PASİF',
        style: AppTextStyles.labelSmall.copyWith(
          color: isActive
              ? AppColors.primary
              : AppColors.onSurfaceVariant,
        ),
      ),
    );
  }
}

class _CountBadge extends StatelessWidget {
  final IconData icon;
  final String label;
  const _CountBadge({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: AppColors.onSurfaceVariant,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: AppTextStyles.labelSmall,
          ),
        ],
      ),
    );
  }
}

class _ActiveDayCard extends StatelessWidget {
  final WeekDay day;
  final List<RoutineExerciseEntity> exercises;
  final int routineId; // ⬅️ YENİ
  final ValueChanged<int> onDelete;

  const _ActiveDayCard({
    required this.day,
    required this.exercises,
    required this.routineId, // ⬅️ YENİ
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(
        AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border(
          left: BorderSide(
            color: AppColors.primary,
            width: 4,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      day.turkishLabel
                          .toUpperCase(),
                      style: AppTextStyles
                          .labelSmall
                          .copyWith(
                            color:
                                AppColors.primary,
                          ),
                    ),
                    const SizedBox(
                      height: AppSpacing.xs,
                    ),
                    Text(
                      '${exercises.length} Hareket',
                      style: AppTextStyles
                          .headlineMedium,
                    ),
                  ],
                ),
              ),
              // ⬇️ YENİ
              FilledButton.icon(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) =>
                          WorkoutSessionPage(
                            routineId: routineId,
                            day: day,
                            exercises: exercises,
                          ),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.play_arrow,
                  size: 18,
                ),
                label: const Text('Başlat'),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          ...exercises.map((routineExercise) {
            return Padding(
              padding: const EdgeInsets.only(
                bottom: AppSpacing.xs,
              ),
              child: Row(
                children: [
                  ExercisePlaceholderThumbnail(
                    imageUrl: routineExercise
                        .exerciseImageUrl,
                    muscleGroupName:
                        routineExercise
                            .exerciseName,
                    size: 44,
                  ),
                  const SizedBox(
                    width: AppSpacing.sm,
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
                      size: 20,
                    ),
                    onPressed: () => onDelete(
                      routineExercise.id,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _RestDayCard extends StatelessWidget {
  final WeekDay day;
  const _RestDayCard({required this.day});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(
        AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHighest
            .withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(
            Icons.hotel,
            color: AppColors.outline.withValues(
              alpha: 0.5,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                day.turkishLabel.toUpperCase(),
                style: AppTextStyles.labelSmall
                    .copyWith(
                      color: AppColors.outline,
                    ),
              ),
              Text(
                'Dinlenme Günü',
                style: AppTextStyles
                    .headlineMedium
                    .copyWith(
                      color: AppColors
                          .onSurfaceVariant,
                      fontStyle: FontStyle.italic,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BioCell extends StatelessWidget {
  final String label;
  final String value;
  const _BioCell({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(
        AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: AppTextStyles.labelSmall,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            value,
            style: AppTextStyles.headlineMedium,
          ),
        ],
      ),
    );
  }
}
