// lib/features/exercise/presentation/pages/exercise_selection_page.dart

import 'package:flutter/material.dart';

import '../../domain/entities/exercise_entity.dart';
import '../widgets/exercise_list_view.dart';

/// Program'a hareket eklerken kullanılan seçim ekranı. Bir hareketin
/// üzerine dokunulunca context.pop(exercise) ile GERİ DÖNER — ekranı
/// açan taraf (ProgramDetailSheet) sonucu bekler.
class ExerciseSelectionPage
    extends StatelessWidget {
  const ExerciseSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hareket Seç'),
      ),
      body: ExerciseListView(
        onExerciseTap: (exercise) => Navigator.of(
          context,
        ).pop<ExerciseEntity>(exercise),
        trailingBuilder: (context, exercise) =>
            const Icon(Icons.chevron_right),
      ),
    );
  }
}
