import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_spacing.dart';
import '../controllers/workout_programs_controller.dart';
import '../widgets/program_creator_sheet.dart';
import '../widgets/program_detail_sheet.dart';

class WorkoutProgramsPage extends ConsumerWidget {
  const WorkoutProgramsPage({super.key});

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final asyncState = ref.watch(
      workoutProgramsControllerProvider,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Antrenman Programları',
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            ProgramCreatorSheet.show(context),
        child: const Icon(Icons.add),
      ),
      body: asyncState.when(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, _) =>
            Center(child: Text('Hata: $error')),
        data: (routines) {
          if (routines.isEmpty) {
            return const Center(
              child: Text(
                'Henüz bir program oluşturmadın.',
              ),
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
                        ProgramDetailSheet.show(
                          context,
                          routine,
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
      ),
    );
  }
}
