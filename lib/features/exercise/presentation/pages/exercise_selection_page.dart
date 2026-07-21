import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/exercise_entity.dart';
import '../controllers/exercise_library_controller.dart';

/// Program'a hareket eklerken kullanılan seçim ekranı. Bir hareketin
/// üzerine dokunulunca context.pop(exercise) ile GERİ DÖNER — ekranı
/// açan taraf (schedule_exercise_sheet) sonucu bekler.
class ExerciseSelectionPage
    extends ConsumerWidget {
  const ExerciseSelectionPage({super.key});

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final asyncState = ref.watch(
      exerciseLibraryControllerProvider,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hareket Seç'),
      ),
      body: asyncState.when(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, _) =>
            Center(child: Text(error.toString())),
        data: (state) => ListView.separated(
          padding: const EdgeInsets.all(
            AppSpacing.containerMargin,
          ),
          itemCount:
              state.filteredExercises.length,
          separatorBuilder: (_, __) =>
              const SizedBox(
                height: AppSpacing.sm,
              ),
          itemBuilder: (context, index) {
            final exercise =
                state.filteredExercises[index];
            return ListTile(
              title: Text(exercise.name),
              subtitle: Text(
                '${exercise.muscleGroupName} • ${exercise.equipmentName}',
              ),
              onTap: () => Navigator.of(
                context,
              ).pop<ExerciseEntity>(exercise),
            );
          },
        ),
      ),
    );
  }
}
