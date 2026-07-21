import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/app_logger.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../exercise/domain/entities/exercise_entity.dart';
import '../../domain/entities/week_day.dart';
import '../controllers/workout_programs_controller.dart';

class ScheduleExerciseSheet
    extends ConsumerStatefulWidget {
  final int routineId;
  final ExerciseEntity exercise;

  const ScheduleExerciseSheet({
    super.key,
    required this.routineId,
    required this.exercise,
  });

  static Future<void> show(
    BuildContext context, {
    required int routineId,
    required ExerciseEntity exercise,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => ScheduleExerciseSheet(
        routineId: routineId,
        exercise: exercise,
      ),
    );
  }

  @override
  ConsumerState<ScheduleExerciseSheet>
  createState() => _ScheduleExerciseSheetState();
}

class _ScheduleExerciseSheetState
    extends ConsumerState<ScheduleExerciseSheet> {
  final _setsController = TextEditingController(
    text: '3',
  );
  final _repsController = TextEditingController(
    text: '8',
  );
  WeekDay _selectedDay = WeekDay.monday;
  bool _isSubmitting = false;
  String? _errorText;

  @override
  void dispose() {
    _setsController.dispose();
    _repsController.dispose();
    super.dispose();
  }

  Future<void> _handleConfirm() async {
    final sets = int.tryParse(
      _setsController.text,
    );
    final reps = int.tryParse(
      _repsController.text,
    );

    if (sets == null ||
        reps == null ||
        sets <= 0 ||
        reps <= 0) {
      setState(
        () => _errorText =
            'Geçerli set ve tekrar sayısı gir.',
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
      _errorText = null;
    });

    try {
      await ref
          .read(
            workoutProgramsControllerProvider
                .notifier,
          )
          .addExerciseToRoutine(
            routineId: widget.routineId,
            exerciseId: widget.exercise.id,
            exerciseName: widget.exercise.name,
            exerciseImageUrl:
                widget.exercise.imageUrl,
            day: _selectedDay,
            targetSets: sets,
            targetReps: reps,
          );
      if (mounted) Navigator.of(context).pop();
    } catch (error, stackTrace) {
      AppLogger.error(
        'ScheduleExerciseSheet - _handleConfirm',
        error,
        stackTrace,
      );
      if (mounted) {
        setState(
          () => _errorText = 'Eklenemedi: $error',
        );
      }
    } finally {
      if (mounted)
        setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(
      context,
    ).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(
        bottom: bottomInset,
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(
          AppSpacing.containerMargin,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Text(
              widget.exercise.name,
              style: Theme.of(
                context,
              ).textTheme.headlineMedium,
            ),
            const SizedBox(height: AppSpacing.lg),
            const Text('Gün'),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.sm,
              children: WeekDay.values.map((day) {
                return ChoiceChip(
                  label: Text(day.turkishLabel),
                  selected: _selectedDay == day,
                  onSelected: (_) => setState(
                    () => _selectedDay = day,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: AppSpacing.lg),
            Row(
              children: [
                Expanded(
                  child: AppTextField(
                    label: 'Set',
                    controller: _setsController,
                    keyboardType:
                        TextInputType.number,
                  ),
                ),
                const SizedBox(
                  width: AppSpacing.md,
                ),
                Expanded(
                  child: AppTextField(
                    label: 'Tekrar',
                    controller: _repsController,
                    keyboardType:
                        TextInputType.number,
                  ),
                ),
              ],
            ),
            if (_errorText != null) ...[
              const SizedBox(
                height: AppSpacing.md,
              ),
              Text(
                _errorText!,
                style: const TextStyle(
                  color: Colors.red,
                ),
              ),
            ],
            const SizedBox(height: AppSpacing.xl),
            PrimaryButton(
              label: 'Programa Ekle',
              isLoading: _isSubmitting,
              onPressed: _handleConfirm,
            ),
          ],
        ),
      ),
    );
  }
}
