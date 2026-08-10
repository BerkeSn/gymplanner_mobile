import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymplanner_mobile/features/exercise_progress/domain/entities/set_detail_entity.dart';
import 'package:gymplanner_mobile/features/exercise_progress/presentation/controllers/exercise_progress_controller.dart';
import 'package:gymplanner_mobile/features/workout_log/domain/entites/workout_set_entity.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/app_logger.dart';
import '../../../../core/widgets/exercise_placeholder_thumbnail.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../exercise_progress/presentation/pages/exercise_progress_page.dart';
import '../../../workout_routine/domain/entities/routine_exercise_entity.dart';
import '../../../workout_routine/domain/entities/week_day.dart';
import '../controllers/workout_session_controller.dart';

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
            120,
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
                exerciseImageUrl: routineExercise
                    .exerciseImageUrl,
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
  final String? exerciseImageUrl;
  final int targetSets;
  final int targetReps;

  const _ExerciseSessionCard({
    required this.routineId,
    required this.exerciseId,
    required this.exerciseName,
    required this.exerciseImageUrl,
    required this.targetSets,
    required this.targetReps,
  });

  @override
  ConsumerState<_ExerciseSessionCard>
  createState() => _ExerciseSessionCardState();
}

class _ExerciseSessionCardState
    extends ConsumerState<_ExerciseSessionCard> {
  final Map<int, TextEditingController>
  _weightControllers = {};
  final Map<int, TextEditingController>
  _repsControllers = {};
  late Set<int> _draftSetNumbers;
  final Set<int> _submittingSetNumbers = {};

  @override
  void initState() {
    super.initState();
    // ⬇️ DÜZELTİ: taslak numarasını devam eden oturumdaki mevcut set
    // sayısına göre başlat — 1'den değil, kaldığı yerden.
    final sessionState = ref
        .read(
          workoutSessionControllerProvider(
            widget.routineId,
          ),
        )
        .valueOrNull;
    final savedCount =
        sessionState
            ?.setsFor(widget.exerciseId)
            .length ??
        0;
    _draftSetNumbers = {savedCount + 1};
  }

  TextEditingController _weightControllerFor(
    int setNumber,
  ) => _weightControllers.putIfAbsent(
    setNumber,
    () => TextEditingController(),
  );

  TextEditingController _repsControllerFor(
    int setNumber,
  ) => _repsControllers.putIfAbsent(
    setNumber,
    () => TextEditingController(
      text: '${widget.targetReps}',
    ),
  );

  @override
  void dispose() {
    for (final c in _weightControllers.values)
      c.dispose();
    for (final c in _repsControllers.values)
      c.dispose();
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
          _draftSetNumbers.add(setNumber + 1);
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
      if (mounted)
        setState(
          () => _submittingSetNumbers.remove(
            setNumber,
          ),
        );
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

  void _openProgressPage() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ExerciseProgressPage(
          exerciseId: widget.exerciseId,
          exerciseName: widget.exerciseName,
          exerciseImageUrl:
              widget.exerciseImageUrl,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
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
    final pendingDrafts =
        _draftSetNumbers
            .where(
              (n) => !savedSetNumbers.contains(n),
            )
            .toList()
          ..sort();

    final progressAsync = ref.watch(
      exerciseProgressProvider(widget.exerciseId),
    );
    final lastSessionSets = _findLastSessionSets(
      progressAsync.valueOrNull,
      sessionState?.workoutLogId,
    );

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
          InkWell(
            // ⬅️ YENİ: fotoğraf/isim tıklanınca Antrenman Kaydı'na gider
            onTap: _openProgressPage,
            borderRadius: BorderRadius.circular(
              12,
            ),
            child: Row(
              children: [
                ExercisePlaceholderThumbnail(
                  imageUrl:
                      widget.exerciseImageUrl,
                  muscleGroupName:
                      widget.exerciseName,
                  size: 48,
                ),
                const SizedBox(
                  width: AppSpacing.md,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.exerciseName,
                        style: AppTextStyles
                            .headlineMedium,
                      ),
                      Text(
                        'Hedef: ${widget.targetSets} set × ${widget.targetReps} tekrar',
                        style: AppTextStyles
                            .bodyMedium,
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: AppColors.outline,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          // ⬇️ YENİ: geçmiş referans — read-only
          if (lastSessionSets != null) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(
                AppSpacing.sm,
              ),
              decoration: BoxDecoration(
                color: AppColors
                    .surfaceContainerHigh
                    .withValues(alpha: 0.5),
                borderRadius:
                    BorderRadius.circular(10),
              ),
              child: Row(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.history,
                    size: 16,
                    color: AppColors.outline,
                  ),
                  const SizedBox(
                    width: AppSpacing.xs,
                  ),
                  Expanded(
                    child: Text(
                      '${l10n.lastSessionLabel}: ${lastSessionSets.map((s) => "${s.weight}kg×${s.reps}").join(", ")}',
                      style: AppTextStyles
                          .bodyMedium,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
          ],

          ...savedSets.map(
            (set) => _SavedSetRow(
              set: set,
              onDelete: () =>
                  _handleRemoveSavedSet(set),
            ),
          ),
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
              final maxNumber =
                  [
                    ...savedSetNumbers,
                    ...pendingDrafts,
                  ].fold(
                    0,
                    (max, n) => n > max ? n : max,
                  );
              setState(
                () => _draftSetNumbers.add(
                  maxNumber + 1,
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

  /// exerciseProgress geçmişinden, BUGÜNKÜ (şu an devam eden) oturuma ait
  /// OLMAYAN en son kaydı bulur — "geçen sefer" bu şekilde belirlenir.
  List<SetDetailEntity>? _findLastSessionSets(
    dynamic history,
    int? currentWorkoutLogId,
  ) {
    if (history == null) return null;
    final list = history as List;
    for (var i = list.length - 1; i >= 0; i--) {
      final entry = list[i];
      if (entry.workoutLogId !=
              currentWorkoutLogId &&
          entry.sets.isNotEmpty) {
        return List<SetDetailEntity>.from(
          entry.sets,
        );
      }
    }
    return null;
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
