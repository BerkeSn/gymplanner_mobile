// presentation/widgets/program_detail_sheet.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymplanner_mobile/features/exercise/presentation/pages/exercise_selection_page.dart';
import 'package:gymplanner_mobile/features/workout_routine/domain/entities/week_day.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../exercise/domain/entities/exercise_entity.dart';
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

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    // Güncel listeden bu routine'in en taze halini bul (ekleme sonrası
    // controller refresh ettiği için sheet açıkken de güncel kalır).
    final routines = ref
        .watch(workoutProgramsControllerProvider)
        .valueOrNull;
    final current =
        routines?.firstWhere(
          (r) => r.id == routine.id,
          orElse: () => routine,
        ) ??
        routine;

    return DraggableScrollableSheet(
      initialChildSize: 0.7,
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
              Text(
                current.name,
                style: Theme.of(
                  context,
                ).textTheme.headlineMedium,
              ),
              if (current.description !=
                  null) ...[
                const SizedBox(
                  height: AppSpacing.xs,
                ),
                Text(current.description!),
              ],
              const SizedBox(
                height: AppSpacing.lg,
              ),
              Expanded(
                child:
                    current
                        .routineExercises
                        .isEmpty
                    ? const Center(
                        child: Text(
                          'Henüz hareket eklenmedi.',
                        ),
                      )
                    : ListView.separated(
                        controller:
                            scrollController,
                        itemCount: current
                            .routineExercises
                            .length,
                        separatorBuilder:
                            (
                              _,
                              __,
                            ) => const SizedBox(
                              height:
                                  AppSpacing.sm,
                            ),
                        itemBuilder: (context, index) {
                          final re = current
                              .routineExercises[index];
                          return ListTile(
                            leading: CircleAvatar(
                              child: Text(
                                re
                                    .day
                                    .turkishLabel
                                    .substring(
                                      0,
                                      2,
                                    ),
                              ),
                            ),
                            title: Text(
                              re.exerciseName,
                            ),
                            subtitle: Text(
                              '${re.targetSets} set × ${re.targetReps} tekrar',
                            ),
                            trailing: IconButton(
                              icon: const Icon(
                                Icons
                                    .delete_outline,
                              ),
                              onPressed: () => ref
                                  .read(
                                    workoutProgramsControllerProvider
                                        .notifier,
                                  )
                                  .removeRoutineExercise(
                                    re.id,
                                  ),
                            ),
                          );
                        },
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

/// ExerciseSelectionPage'i modal olarak MaterialPageRoute ile açmak için
/// ince bir sarmalayıcı — go_router shell'inin dışında bağımsız bir sayfa
/// olarak push edildiği için AppRoutes'a eklemeye gerek yok.

