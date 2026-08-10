// lib/features/workout_routine/presentation/pages/workout_programs_page.dart
// Dosyanın TAMAMINI şununla değiştir:

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../exercise/presentation/controllers/exercise_library_controller.dart';
import '../../../exercise/presentation/widgets/exercise_list_view.dart';
import '../../../exercise_progress/presentation/pages/exercise_progress_page.dart';
import '../controllers/workout_programs_controller.dart';
import '../widgets/program_creator_sheet.dart';
import 'program_detail_page.dart';

class WorkoutProgramsPage
    extends ConsumerStatefulWidget {
  const WorkoutProgramsPage({super.key});

  @override
  ConsumerState<WorkoutProgramsPage>
  createState() => _WorkoutProgramsPageState();
}

class _WorkoutProgramsPageState
    extends ConsumerState<WorkoutProgramsPage> {
  int _tabIndex = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.fitnessTitle),
      ),
      floatingActionButton: _tabIndex == 0
          ? FloatingActionButton(
              onPressed: () =>
                  ProgramCreatorSheet.show(
                    context,
                  ),
              child: const Icon(Icons.add),
            )
          : null,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(
              AppSpacing.containerMargin,
            ),
            child: SegmentedButton<int>(
              segments: [
                ButtonSegment(
                  value: 0,
                  label: Text(l10n.myProgramsTab),
                ),
                ButtonSegment(
                  value: 1,
                  label: Text(l10n.libraryTab),
                ),
              ],
              selected: {_tabIndex},
              onSelectionChanged: (selected) =>
                  setState(
                    () => _tabIndex =
                        selected.first,
                  ),
            ),
          ),
          // IndexedStack: sekme değişince controller'lar dispose OLMASIN —
          // programlar listesi ile kütüphane arasında geçiş yaparken
          // yeniden veri çekme/flicker yaşanmaz.
          Expanded(
            child: IndexedStack(
              index: _tabIndex,
              children: [
                _ProgramsTab(),
                ExerciseListView(
                  onExerciseTap: (exercise) =>
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) =>
                              ExerciseProgressPage(
                                exerciseId:
                                    exercise.id,
                                exerciseName: exercise.name,    
                              ),
                        ),
                      ),
                  trailingBuilder: (context, exercise) {
                    final favoriteIds =
                        ref
                            .watch(
                              exerciseLibraryControllerProvider,
                            )
                            .valueOrNull
                            ?.favoriteIds ??
                        {};
                    final isFavorite = favoriteIds
                        .contains(exercise.id);
                    return IconButton(
                      icon: Icon(
                        isFavorite
                            ? Icons.favorite
                            : Icons
                                  .favorite_border,
                        color: isFavorite
                            ? AppColors.error
                            : AppColors.outline,
                      ),
                      onPressed: () => ref
                          .read(
                            exerciseLibraryControllerProvider
                                .notifier,
                          )
                          .toggleFavorite(
                            exercise.id,
                          ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgramsTab extends ConsumerWidget {
  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final l10n = AppLocalizations.of(context);
    final asyncState = ref.watch(
      workoutProgramsControllerProvider,
    );

    return asyncState.when(
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (error, _) =>
          Center(child: Text('Hata: $error')),
      data: (routines) {
        if (routines.isEmpty) {
          return Center(
            child: Text(l10n.noProgramsYet),
          );
        }
        return RefreshIndicator(
          onRefresh: () => ref
              .read(
                workoutProgramsControllerProvider
                    .notifier,
              )
              .refresh(),
          child: ListView.separated(
            padding: const EdgeInsets.all(
              AppSpacing.containerMargin,
            ),
            itemCount: routines.length,
            separatorBuilder: (_, __) =>
                const SizedBox(
                  height: AppSpacing.md,
                ),
            itemBuilder: (context, index) {
              final routine = routines[index];
              return Card(
                child: ListTile(
                  onTap: () =>
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) =>
                              ProgramDetailPage(
                                routineId:
                                    routine.id,
                              ),
                        ),
                      ),
                  title: Text(routine.name),
                  subtitle: Text(
                    '${routine.routineExercises.length} hareket',
                  ),
                  trailing: Switch(
                    value: routine.isActive,
                    onChanged: (_) => ref
                        .read(
                          workoutProgramsControllerProvider
                              .notifier,
                        )
                        .toggleActive(routine),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
