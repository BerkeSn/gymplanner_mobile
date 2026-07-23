import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymplanner_mobile/features/body_measurement/domain/entites/measurement_goal.dart';
import 'package:gymplanner_mobile/features/body_measurement/presentation/controller/body_measurement_controller.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/app_logger.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../l10n/app_localizations.dart';

class AddMeasurementSheet
    extends ConsumerStatefulWidget {
  const AddMeasurementSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => const AddMeasurementSheet(),
    );
  }

  @override
  ConsumerState<AddMeasurementSheet>
  createState() => _AddMeasurementSheetState();
}

class _AddMeasurementSheetState
    extends ConsumerState<AddMeasurementSheet> {
  final _weightController =
      TextEditingController();
  final _heightController =
      TextEditingController();
  final _neckController = TextEditingController();
  final _waistController =
      TextEditingController();
  final _bodyFatController =
      TextEditingController();
  MeasurementGoal _selectedGoal =
      MeasurementGoal.maintain;
  DateTime _selectedDate = DateTime.now();
  bool _isSubmitting = false;
  String? _errorText;

  @override
  void dispose() {
    _weightController.dispose();
    _heightController.dispose();
    _neckController.dispose();
    _waistController.dispose();
    _bodyFatController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    final l10n = AppLocalizations.of(context);
    final weight = double.tryParse(
      _weightController.text,
    );
    final height = double.tryParse(
      _heightController.text,
    );

    if (weight == null || height == null) {
      setState(
        () => _errorText =
            l10n.validationWeightHeightRequired,
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
      _errorText = null;
    });

    try {
      final success = await ref
          .read(
            bodyMeasurementControllerProvider
                .notifier,
          )
          .addMeasurement(
            date: _selectedDate,
            weight: weight,
            height: height,
            neck: double.tryParse(
              _neckController.text,
            ),
            waist: double.tryParse(
              _waistController.text,
            ),
            bodyFatPercentage: double.tryParse(
              _bodyFatController.text,
            ),
            goal: _selectedGoal,
          );

      if (!mounted) return;

      if (success) {
        Navigator.of(context).pop();
      } else {
        setState(
          () => _errorText =
              l10n.measurementSaveError,
        );
      }
    } catch (error, stackTrace) {
      AppLogger.error(
        'AddMeasurementSheet - _handleSave',
        error,
        stackTrace,
      );
    } finally {
      if (mounted)
        setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
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
              l10n.addMeasurementTitle,
              style: Theme.of(
                context,
              ).textTheme.headlineMedium,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(l10n.addMeasurementSubtitle),
            const SizedBox(height: AppSpacing.lg),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(l10n.dateLabel),
              trailing: Text(
                '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
              ),
              onTap: () async {
                final picked =
                    await showDatePicker(
                      context: context,
                      initialDate: _selectedDate,
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now(),
                    );
                if (picked != null)
                  setState(
                    () => _selectedDate = picked,
                  );
              },
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: AppTextField(
                    label: l10n.weightLabelKg,
                    controller: _weightController,
                    keyboardType:
                        const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                  ),
                ),
                const SizedBox(
                  width: AppSpacing.md,
                ),
                Expanded(
                  child: AppTextField(
                    label: l10n.heightLabelCm,
                    controller: _heightController,
                    keyboardType:
                        TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: AppTextField(
                    label: l10n.neckLabelCm,
                    controller: _neckController,
                    keyboardType:
                        TextInputType.number,
                  ),
                ),
                const SizedBox(
                  width: AppSpacing.md,
                ),
                Expanded(
                  child: AppTextField(
                    label: l10n.waistLabelCm,
                    controller: _waistController,
                    keyboardType:
                        TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            AppTextField(
              label: l10n.bodyFatLabel,
              controller: _bodyFatController,
              keyboardType:
                  const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              l10n.goalLabel,
              style: Theme.of(
                context,
              ).textTheme.labelSmall,
            ),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.sm,
              children: [
                ChoiceChip(
                  label: Text(
                    l10n.goalLoseWeight,
                  ),
                  selected:
                      _selectedGoal ==
                      MeasurementGoal.loseWeight,
                  onSelected: (_) => setState(
                    () => _selectedGoal =
                        MeasurementGoal
                            .loseWeight,
                  ),
                ),
                ChoiceChip(
                  label: Text(
                    l10n.goalGainMuscle,
                  ),
                  selected:
                      _selectedGoal ==
                      MeasurementGoal.gainMuscle,
                  onSelected: (_) => setState(
                    () => _selectedGoal =
                        MeasurementGoal
                            .gainMuscle,
                  ),
                ),
                ChoiceChip(
                  label: Text(l10n.goalMaintain),
                  selected:
                      _selectedGoal ==
                      MeasurementGoal.maintain,
                  onSelected: (_) => setState(
                    () => _selectedGoal =
                        MeasurementGoal.maintain,
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
              label: l10n.saveMeasurementButton,
              isLoading: _isSubmitting,
              onPressed: _handleSave,
            ),
          ],
        ),
      ),
    );
  }
}
