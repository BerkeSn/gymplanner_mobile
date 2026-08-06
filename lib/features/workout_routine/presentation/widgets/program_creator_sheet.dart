import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymplanner_mobile/core/widgets/labeled_dropdown.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/app_logger.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../domain/entities/training_goal.dart';
import '../controllers/workout_programs_controller.dart';

/// standardized_program_creator_modal.html temel alınmıştır.
/// Days/Week ve Training Goal artık backend'de gerçek karşılığı olan
/// (daysPerWeek, trainingGoal) alanlar — mockup'taki görsel dile birebir
/// sadık kalınmıştır (2 kolonlu dropdown grid).
class ProgramCreatorSheet
    extends ConsumerStatefulWidget {
  const ProgramCreatorSheet({super.key});

  @override
  ConsumerState<ProgramCreatorSheet>
  createState() => _ProgramCreatorSheetState();

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => const ProgramCreatorSheet(),
    );
  }
}

class _ProgramCreatorSheetState
    extends ConsumerState<ProgramCreatorSheet> {
  final _nameController = TextEditingController();
  final _descriptionController =
      TextEditingController();
  int _selectedDaysPerWeek = 3;
  TrainingGoal _selectedGoal =
      TrainingGoal.hypertrophy;
  bool _isSubmitting = false;
  String? _errorText;

  static const _dayOptions = [3, 4, 5, 6];

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _handleCreate() async {
    if (_nameController.text.trim().isEmpty) {
      setState(
        () => _errorText =
            'Program adı zorunludur.',
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
          .createProgram(
            name: _nameController.text.trim(),
            description:
                _descriptionController.text
                    .trim()
                    .isEmpty
                ? null
                : _descriptionController.text
                      .trim(),
            daysPerWeek: _selectedDaysPerWeek,
            trainingGoal: _selectedGoal,
          );
      if (mounted) Navigator.of(context).pop();
    } catch (error, stackTrace) {
      AppLogger.error(
        'ProgramCreatorSheet - _handleCreate',
        error,
        stackTrace,
      );
      if (mounted) {
        setState(
          () => _errorText =
              'Program oluşturulamadı: $error',
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
              'Yeni Program',
              style: AppTextStyles.headlineMedium,
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Program Adı',
              style: AppTextStyles.labelSmall,
            ),
            const SizedBox(height: AppSpacing.sm),
            AppTextField(
              label: 'Örn. Minimalist Kuvvet',
              controller: _nameController,
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Açıklama',
              style: AppTextStyles.labelSmall,
            ),
            const SizedBox(height: AppSpacing.sm),
            AppTextField(
              label:
                  'Bu programın odağını tanımla...',
              controller: _descriptionController,
            ),
            const SizedBox(height: AppSpacing.lg),

            // ⬇️ YENİ: Mockup'taki 2 kolonlu grid (Days/Week + Training Goal)
            Row(
              children: [
                Expanded(
                  child: LabeledDropdown<int>(
                    label: 'Gün / Hafta',
                    value: _selectedDaysPerWeek,
                    items: _dayOptions
                        .map(
                          (d) => DropdownMenuItem(
                            value: d,
                            child: Text('$d Gün'),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(
                          () =>
                              _selectedDaysPerWeek =
                                  value,
                        );
                      }
                    },
                  ),
                ),
                const SizedBox(
                  width: AppSpacing.md,
                ),
                Expanded(
                  child:
                      LabeledDropdown<
                        TrainingGoal
                      >(
                        label: 'Antrenman Hedefi',
                        value: _selectedGoal,
                        items: TrainingGoal.values
                            .map(
                              (
                                goal,
                              ) => DropdownMenuItem(
                                value: goal,
                                child: Text(
                                  goal.turkishLabel,
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(
                              () =>
                                  _selectedGoal =
                                      value,
                            );
                          }
                        },
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
              label: 'Program Oluştur',
              isLoading: _isSubmitting,
              onPressed: _handleCreate,
            ),
          ],
        ),
      ),
    );
  }
}

/// Mockup'taki "input-premium" stilindeki select kutusu — AppTextField'ın
/// dropdown karşılığı. Tema renklerinden bağımsız hardcode yok.
class _LabeledDropdown<T>
    extends StatelessWidget {
  final String label;
  final T value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;

  const _LabeledDropdown({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.labelSmall,
        ),
        const SizedBox(height: AppSpacing.sm),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
          ),
          decoration: BoxDecoration(
            color:
                AppColors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(
              12,
            ),
            border: Border.all(
              color: AppColors.outlineVariant,
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<T>(
              value: value,
              isExpanded: true,
              items: items,
              onChanged: onChanged,
              style: AppTextStyles.bodyLarge,
              icon: Icon(
                Icons.expand_more,
                color: AppColors.outline,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
