import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymplanner_mobile/features/nutrition/domain/entites/meal_type.dart';
import 'package:gymplanner_mobile/features/nutrition/presentation/controller/nutrition_controller.dart';
import 'package:gymplanner_mobile/features/nutrition/presentation/providers/meals_for_date_provider.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/app_logger.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../l10n/app_localizations.dart';

class LogMealSheet
    extends ConsumerStatefulWidget {
  final DateTime date;
  const LogMealSheet({
    super.key,
    required this.date,
  });

  static Future<void> show(
    BuildContext context, {
    DateTime? date,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => LogMealSheet(
        date: date ?? DateTime.now(),
      ),
    );
  }

  @override
  ConsumerState<LogMealSheet> createState() =>
      _LogMealSheetState();
}

class _LogMealSheetState
    extends ConsumerState<LogMealSheet> {
  final _nameController = TextEditingController();
  final _weightController =
      TextEditingController();
  final _caloriesController =
      TextEditingController();
  final _proteinController =
      TextEditingController();
  final _carbsController =
      TextEditingController();
  final _fatsController = TextEditingController();
  // MealType _selectedType = MealType.snack;
  bool _isSubmitting = false;
  String? _errorText;

  @override
  void dispose() {
    _nameController.dispose();
    _weightController.dispose();
    _caloriesController.dispose();
    _proteinController.dispose();
    _carbsController.dispose();
    _fatsController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    final l10n = AppLocalizations.of(context);
    final calories = int.tryParse(
      _caloriesController.text,
    );

    if (_nameController.text.trim().isEmpty ||
        calories == null) {
      setState(
        () => _errorText = l10n
            .validationMealNameCaloriesRequired,
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
            nutritionControllerProvider.notifier,
          )
          .addMeal(
            date: widget.date, // ⬅️ YENİ
            mealType: MealType.snack,
            name: _nameController.text.trim(),
            servingWeight: double.tryParse(
              _weightController.text,
            ),
            calories: calories,
            protein:
                double.tryParse(
                  _proteinController.text,
                ) ??
                0,
            carbs:
                double.tryParse(
                  _carbsController.text,
                ) ??
                0,
            fats:
                double.tryParse(
                  _fatsController.text,
                ) ??
                0,
          );

      if (!mounted) return;

      if (success) {
        ref.invalidate(
          mealsForDateProvider(widget.date),
        ); // ⬅️ YENİ: Dashboard'daki liste tazelensin
        Navigator.of(context).pop();
      } else {
        setState(
          () => _errorText = l10n.mealSaveError,
        );
      }
    } catch (error, stackTrace) {
      AppLogger.error(
        'LogMealSheet - _handleSave',
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
              'Öğün Ekle',
              style: Theme.of(
                context,
              ).textTheme.headlineMedium,
            ),
            const SizedBox(height: AppSpacing.lg),
            // Wrap(
            //   spacing: AppSpacing.sm,
            //   children: [
            //     ChoiceChip(
            //       label: Text(
            //         l10n.mealTypeBreakfast,
            //       ),
            //       selected:
            //           _selectedType ==
            //           MealType.breakfast,
            //       onSelected: (_) => setState(
            //         () => _selectedType =
            //             MealType.breakfast,
            //       ),
            //     ),
            //     ChoiceChip(
            //       label: Text(l10n.mealTypeLunch),
            //       selected:
            //           _selectedType ==
            //           MealType.lunch,
            //       onSelected: (_) => setState(
            //         () => _selectedType =
            //             MealType.lunch,
            //       ),
            //     ),
            //     ChoiceChip(
            //       label: Text(
            //         l10n.mealTypeDinner,
            //       ),
            //       selected:
            //           _selectedType ==
            //           MealType.dinner,
            //       onSelected: (_) => setState(
            //         () => _selectedType =
            //             MealType.dinner,
            //       ),
            //     ),
            //     ChoiceChip(
            //       label: Text(l10n.mealTypeSnack),
            //       selected:
            //           _selectedType ==
            //           MealType.snack,
            //       onSelected: (_) => setState(
            //         () => _selectedType =
            //             MealType.snack,
            //       ),
            //     ),
            //   ],
            // ),
            
            const SizedBox(height: AppSpacing.lg),
            AppTextField(
              label: l10n.mealNameLabel,
              controller: _nameController,
            ),
            const SizedBox(height: AppSpacing.md),
            AppTextField(
              label: l10n.servingWeightLabel,
              controller: _weightController,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: AppSpacing.md),
            AppTextField(
              label: l10n.totalCaloriesLabel,
              controller: _caloriesController,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: AppTextField(
                    label: l10n.proteinLabel,
                    controller:
                        _proteinController,
                    keyboardType:
                        const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                  ),
                ),
                const SizedBox(
                  width: AppSpacing.sm,
                ),
                Expanded(
                  child: AppTextField(
                    label: l10n.carbsLabel,
                    controller: _carbsController,
                    keyboardType:
                        const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                  ),
                ),
                const SizedBox(
                  width: AppSpacing.sm,
                ),
                Expanded(
                  child: AppTextField(
                    label: l10n.fatsLabel,
                    controller: _fatsController,
                    keyboardType:
                        const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
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
              label: l10n.saveMealButton,
              isLoading: _isSubmitting,
              onPressed: _handleSave,
            ),
          ],
        ),
      ),
    );
  }
}
