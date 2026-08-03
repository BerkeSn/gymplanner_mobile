import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymplanner_mobile/features/workout_log/domain/entites/workout_set_entity.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/app_logger.dart';
import '../../../workout_routine/domain/entities/routine_exercise_entity.dart';
import '../../../workout_routine/domain/entities/week_day.dart';
import '../controllers/workout_session_controller.dart';

/// standardized_workout_session.html temel alınmıştır.
class WorkoutSessionPage extends ConsumerWidget {
  final int routineId;
  final WeekDay day;
  final List<RoutineExerciseEntity> exercises;

  const WorkoutSessionPage({
    super.key,
    required this.routineId,
    required this.day,
    required this.exercises,
  });

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final asyncState = ref.watch(
      workoutSessionControllerProvider(routineId),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${day.turkishLabel} Antrenmanı',
        ),
      ),
      body: asyncState.when(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(
              AppSpacing.lg,
            ),
            child: Text(
              'Oturum başlatılamadı: $error',
            ),
          ),
        ),
        data: (_) => ListView.builder(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.containerMargin,
            AppSpacing.containerMargin,
            AppSpacing.containerMargin,
            120, // sticky footer'a yer açmak için
          ),
          itemCount: exercises.length,
          itemBuilder: (context, index) {
            final routineExercise =
                exercises[index];
            return Padding(
              padding: const EdgeInsets.only(
                bottom: AppSpacing.lg,
              ),
              child: _ExerciseSessionCard(
                routineId: routineId,
                exerciseId:
                    routineExercise.exerciseId,
                exerciseName:
                    routineExercise.exerciseName,
                targetSets:
                    routineExercise.targetSets,
                targetReps:
                    routineExercise.targetReps,
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(
            AppSpacing.containerMargin,
          ),
          child: FilledButton.icon(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Antrenman kaydedildi!',
                  ),
                ),
              );
            },
            icon: const Icon(
              Icons.check_circle_outline,
            ),
            label: const Text('Antrenmanı Bitir'),
          ),
        ),
      ),
    );
  }
}

class _ExerciseSessionCard
    extends ConsumerStatefulWidget {
  final int routineId;
  final int exerciseId;
  final String exerciseName;
  final int targetSets;
  final int targetReps;

  const _ExerciseSessionCard({
    required this.routineId,
    required this.exerciseId,
    required this.exerciseName,
    required this.targetSets,
    required this.targetReps,
  });

  @override
  ConsumerState<_ExerciseSessionCard>
  createState() => _ExerciseSessionCardState();
}

class _ExerciseSessionCardState
    extends ConsumerState<_ExerciseSessionCard> {
  // Her taslak satır için ayrı controller çifti — set numarasına göre anahtarlanır.
  final Map<int, TextEditingController>
  _weightControllers = {};
  final Map<int, TextEditingController>
  _repsControllers = {};
  final Set<int> _draftSetNumbers = {
    1,
  }; // en az bir taslak satırla başla
  final Set<int> _submittingSetNumbers = {};

  TextEditingController _weightControllerFor(
    int setNumber,
  ) {
    return _weightControllers.putIfAbsent(
      setNumber,
      () => TextEditingController(),
    );
  }

  TextEditingController _repsControllerFor(
    int setNumber,
  ) {
    return _repsControllers.putIfAbsent(
      setNumber,
      () => TextEditingController(
        text: '${widget.targetReps}',
      ),
    );
  }

  @override
  void dispose() {
    for (final c in _weightControllers.values) {
      c.dispose();
    }
    for (final c in _repsControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _submitSet(int setNumber) async {
    final weight = double.tryParse(
      _weightControllerFor(setNumber).text,
    );
    final reps = int.tryParse(
      _repsControllerFor(setNumber).text,
    );

    if (weight == null ||
        reps == null ||
        weight <= 0 ||
        reps <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Geçerli ağırlık ve tekrar sayısı gir.',
          ),
        ),
      );
      return;
    }

    setState(
      () => _submittingSetNumbers.add(setNumber),
    );

    try {
      final success = await ref
          .read(
            workoutSessionControllerProvider(
              widget.routineId,
            ).notifier,
          )
          .addSet(
            exerciseId: widget.exerciseId,
            setNumber: setNumber,
            reps: reps,
            weight: weight,
          );

      if (!mounted) return;

      if (success) {
        setState(() {
          _draftSetNumbers.remove(setNumber);
          _draftSetNumbers.add(
            setNumber + 1,
          ); // sıradaki set için yeni taslak
        });
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(
          const SnackBar(
            content: Text(
              'Set kaydedilemedi, tekrar dene.',
            ),
          ),
        );
      }
    } catch (error, stackTrace) {
      AppLogger.error(
        '_ExerciseSessionCard - _submitSet',
        error,
        stackTrace,
      );
    } finally {
      if (mounted) {
        setState(
          () => _submittingSetNumbers.remove(
            setNumber,
          ),
        );
      }
    }
  }

  Future<void> _handleRemoveSavedSet(
    WorkoutSetEntity set,
  ) async {
    try {
      await ref
          .read(
            workoutSessionControllerProvider(
              widget.routineId,
            ).notifier,
          )
          .removeSet(
            exerciseId: widget.exerciseId,
            setId: set.id,
          );
    } catch (error, stackTrace) {
      AppLogger.error(
        '_ExerciseSessionCard - _handleRemoveSavedSet',
        error,
        stackTrace,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final sessionState = ref
        .watch(
          workoutSessionControllerProvider(
            widget.routineId,
          ),
        )
        .valueOrNull;
    final savedSets =
        sessionState?.setsFor(
          widget.exerciseId,
        ) ??
        [];
    final savedSetNumbers = savedSets
        .map((s) => s.setNumber)
        .toSet();

    // Taslak numaraları arasından zaten kaydedilmiş olanları filtrele
    // (aynı ekranda hızlı ardışık kayıt sırasında çakışma olmasın diye).
    final pendingDrafts =
        _draftSetNumbers
            .where(
              (n) => !savedSetNumbers.contains(n),
            )
            .toList()
          ..sort();

    return Container(
      padding: const EdgeInsets.all(
        AppSpacing.lg,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.outlineVariant
              .withValues(alpha: 0.15),
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Text(
            widget.exerciseName,
            style: AppTextStyles.headlineMedium,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Hedef: ${widget.targetSets} set × ${widget.targetReps} tekrar',
            style: AppTextStyles.bodyMedium,
          ),
          const SizedBox(height: AppSpacing.md),

          // Kaydedilmiş (committed) satırlar — disabled, tik ikonlu.
          ...savedSets.map(
            (set) => _SavedSetRow(
              set: set,
              onDelete: () =>
                  _handleRemoveSavedSet(set),
            ),
          ),

          // Taslak (draft) satırlar — aktif input.
          ...pendingDrafts.map(
            (setNumber) => _DraftSetRow(
              setNumber: setNumber,
              weightController:
                  _weightControllerFor(setNumber),
              repsController: _repsControllerFor(
                setNumber,
              ),
              isSubmitting: _submittingSetNumbers
                  .contains(setNumber),
              onConfirm: () =>
                  _submitSet(setNumber),
            ),
          ),

          const SizedBox(height: AppSpacing.sm),
          OutlinedButton.icon(
            onPressed: () {
              final nextNumber =
                  (savedSetNumbers.isEmpty
                      ? pendingDrafts.isEmpty
                            ? 0
                            : pendingDrafts.last
                      : [
                          ...savedSetNumbers,
                          ...pendingDrafts,
                        ].reduce(
                          (a, b) => a > b ? a : b,
                        )) +
                  1;
              setState(
                () => _draftSetNumbers.add(
                  nextNumber,
                ),
              );
            },
            icon: const Icon(Icons.add),
            label: const Text('Set Ekle'),
          ),
        ],
      ),
    );
  }
}

class _SavedSetRow extends StatelessWidget {
  final WorkoutSetEntity set;
  final VoidCallback onDelete;

  const _SavedSetRow({
    required this.set,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: AppSpacing.xs,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              Icons.check_circle,
              color: AppColors.primary,
              size: 20,
            ),
            const SizedBox(width: AppSpacing.sm),
            Text(
              'SET ${set.setNumber}',
              style: AppTextStyles.labelSmall,
            ),
            const Spacer(),
            Text(
              '${set.weight} kg',
              style: AppTextStyles.bodyLarge,
            ),
            const SizedBox(width: AppSpacing.md),
            Text(
              '${set.reps} tekrar',
              style: AppTextStyles.bodyLarge,
            ),
            IconButton(
              icon: const Icon(
                Icons.close,
                size: 18,
              ),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}

class _DraftSetRow extends StatelessWidget {
  final int setNumber;
  final TextEditingController weightController;
  final TextEditingController repsController;
  final bool isSubmitting;
  final VoidCallback onConfirm;

  const _DraftSetRow({
    required this.setNumber,
    required this.weightController,
    required this.repsController,
    required this.isSubmitting,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: AppSpacing.xs,
      ),
      child: Container(
        padding: const EdgeInsets.all(
          AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.outlineVariant
                .withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 28,
              child: Text(
                '$setNumber',
                style: AppTextStyles.labelSmall,
              ),
            ),
            Expanded(
              child: TextField(
                controller: weightController,
                keyboardType:
                    const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                decoration: const InputDecoration(
                  hintText: 'kg',
                  isDense: true,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: TextField(
                controller: repsController,
                keyboardType:
                    TextInputType.number,
                decoration: const InputDecoration(
                  hintText: 'tekrar',
                  isDense: true,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            isSubmitting
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child:
                        CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                  )
                : IconButton(
                    icon: Icon(
                      Icons.check_circle_outline,
                      color: AppColors.primary,
                    ),
                    onPressed: onConfirm,
                  ),
          ],
        ),
      ),
    );
  }
}
