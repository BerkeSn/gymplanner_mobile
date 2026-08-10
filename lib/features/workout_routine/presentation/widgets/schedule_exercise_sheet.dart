// lib/features/workout_routine/presentation/widgets/schedule_exercise_sheet.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymplanner_mobile/features/workout_routine/domain/entities/routine_exercise_entity.dart';
import 'package:gymplanner_mobile/l10n/app_localizations.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/app_logger.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/exercise_placeholder_thumbnail.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../exercise/domain/entities/exercise_entity.dart';
import '../../domain/entities/week_day.dart';
import '../controllers/workout_programs_controller.dart';

class ScheduleExerciseSheet
    extends ConsumerStatefulWidget {
  final int routineId;
  final ExerciseEntity?
  exercise; // Ekleme modunda dolu
  final RoutineExerciseEntity?
  existing; // Düzenleme modunda dolu

  const ScheduleExerciseSheet({
    super.key,
    required this.routineId,
    this.exercise,
    this.existing,
  });

  static Future<void> show(
    BuildContext context, {
    required int routineId,
    required ExerciseEntity exercise,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => FractionallySizedBox(
        heightFactor: 0.92,
        child: ScheduleExerciseSheet(
          routineId: routineId,
          exercise: exercise,
        ),
      ),
    );
  }

  static Future<void> showEdit(
    BuildContext context, {
    required int routineId,
    required RoutineExerciseEntity existing,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => ScheduleExerciseSheet(
        routineId: routineId,
        existing: existing,
      ),
    );
  }

 @override
  ConsumerState<ScheduleExerciseSheet>
  createState() => _ScheduleExerciseSheetState();
}

class _ScheduleExerciseSheetState
    extends ConsumerState<ScheduleExerciseSheet> {
  late final TextEditingController
  _setsController;
  late final TextEditingController
  _repsController;
  late WeekDay _selectedDay;
  bool _isSubmitting = false;
  String? _errorText;

  bool get _isEditMode => widget.existing != null;
  String get _displayName =>
      widget.existing?.exerciseName ??
      widget.exercise!.name;
  String? get _displayImageUrl =>
      widget.existing?.exerciseImageUrl ??
      widget.exercise?.imageUrl;

  @override
  void initState() {
    super.initState();
    _setsController = TextEditingController(
      text: '${widget.existing?.targetSets ?? 3}',
    );
    _repsController = TextEditingController(
      text:
          '${widget.existing?.targetReps ?? (widget.exercise?.name != null ? 8 : 8)}',
    );
    _selectedDay =
        widget.existing?.day ?? WeekDay.monday;
  }

  
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
      final controller = ref.read(
        workoutProgramsControllerProvider
            .notifier,
      );
      if (_isEditMode) {
        await controller.updateRoutineExercise(
          routineExerciseId: widget.existing!.id,
          day: _selectedDay,
          targetSets: sets,
          targetReps: reps,
        );
      } else {
        await controller.addExerciseToRoutine(
          routineId: widget.routineId,
          exerciseId: widget.exercise!.id,
          exerciseName: widget.exercise!.name,
          exerciseImageUrl:
              widget.exercise!.imageUrl,
          day: _selectedDay,
          targetSets: sets,
          targetReps: reps,
        );
      }
      if (mounted) Navigator.of(context).pop();
    } catch (error, stackTrace) {
      AppLogger.error(
        'ScheduleExerciseSheet - _handleConfirm',
        error,
        stackTrace,
      );
      if (mounted)
        setState(
          () => _errorText =
              'İşlem başarısız: $error',
        );
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
    final screenHeight = MediaQuery.of(
      context,
    ).size.height;

    return Padding(
      padding: EdgeInsets.only(
        bottom: bottomInset,
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(
          AppSpacing.containerMargin,
        ),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(
                bottom: AppSpacing.md,
              ),
              decoration: BoxDecoration(
                color: AppColors.outlineVariant,
                borderRadius:
                    BorderRadius.circular(999),
              ),
            ),
            Text(
              _displayName,
              style: AppTextStyles.headlineMedium,
            ),
            const SizedBox(height: AppSpacing.md),

            // ⬇️ YENİ: Başlık ile gün seçimi arasında, tam genişlikte,
            // ekran yüksekliğinin büyük bir kısmını kaplayan hero görsel.
            ExercisePlaceholderHero(
              imageUrl: _displayImageUrl,
              muscleGroupName: _displayName,
              height: screenHeight * 0.34,
            ),

            const SizedBox(height: AppSpacing.lg),
            if (widget.exercise != null)
              Text(
                '${widget.exercise!.muscleGroupName} • ${widget.exercise!.equipmentName}',
                style: AppTextStyles.bodyMedium,
              ),
            const SizedBox(height: AppSpacing.lg),

            Text(
              'Gün',
              style: AppTextStyles.labelSmall,
            ),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: WeekDay.values.map((day) {
                final isSelected =
                    _selectedDay == day;
                return ChoiceChip(
                  label: Text(day.turkishLabel),
                  selected: isSelected,
                  onSelected: (_) => setState(
                    () => _selectedDay = day,
                  ),
                  // ⬇️ DEĞİŞTİ: Açıkça mavi (AppColors.primary), Material'ın
                  // varsayılan ikincil rengi yerine.
                  selectedColor:
                      AppColors.primary,
                  backgroundColor: AppColors
                      .surfaceContainerLow,
                  showCheckmark: false,
                  labelStyle: TextStyle(
                    color: isSelected
                        ? AppColors.onPrimary
                        : AppColors
                              .onSurfaceVariant,
                    fontWeight: isSelected
                        ? FontWeight.w600
                        : FontWeight.w400,
                  ),
                  side: BorderSide(
                    color: isSelected
                        ? AppColors.primary
                        : AppColors
                              .outlineVariant,
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
              label: AppLocalizations.of(
                context,
              ).updateButton,
              isLoading: _isSubmitting,
              onPressed: _handleConfirm,
            ),
            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
    );
  }
}
