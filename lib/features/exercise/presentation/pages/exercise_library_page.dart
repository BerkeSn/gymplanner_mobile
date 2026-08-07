// lib/features/exercise/presentation/pages/exercise_library_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../exercise_progress/presentation/pages/exercise_progress_page.dart'; // ⬅️ YENİ
import '../controllers/exercise_library_controller.dart';
import '../widgets/exercise_list_view.dart';

class ExerciseLibraryPage extends ConsumerWidget {
  const ExerciseLibraryPage({super.key});

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Egzersiz Kütüphanesi'),
      ),
      body: ExerciseListView(
        showFavoritesFilter: true,
        onExerciseTap: (exercise) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) =>
                  ExerciseProgressPage(
                    exercise: exercise,
                  ),
            ),
          );
        },
        trailingBuilder: (context, exercise) {
          final favoriteIds =
              ref
                  .watch(
                    exerciseLibraryControllerProvider,
                  )
                  .valueOrNull
                  ?.favoriteIds ??
              {};
          final isFavorite = favoriteIds.contains(
            exercise.id,
          );
          return IconButton(
            icon: Icon(
              isFavorite
                  ? Icons.favorite
                  : Icons.favorite_border,
              color: isFavorite
                  ? AppColors.error
                  : AppColors.outline,
            ),
            onPressed: () => ref
                .read(
                  exerciseLibraryControllerProvider
                      .notifier,
                )
                .toggleFavorite(exercise.id),
          );
        },
      ),
    );
  }
}
