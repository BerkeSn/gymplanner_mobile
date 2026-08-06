import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymplanner_mobile/features/body_measurement/domain/entites/body_measurement_entity.dart';
import 'package:gymplanner_mobile/features/body_measurement/presentation/controller/body_measurement_controller.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/app_logger.dart';
import '../../../../core/utils/body_fat_calculator.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';

class AddMeasurementSheet
    extends ConsumerStatefulWidget {
  /// Doluysa DÜZENLEME modu, boşsa yeni ölçüm modu.
  final BodyMeasurementEntity? existing;

  const AddMeasurementSheet({
    super.key,
    this.existing,
  });

  static Future<void> show(
    BuildContext context, {
    BodyMeasurementEntity? existing,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) =>
          AddMeasurementSheet(existing: existing),
    );
  }

  @override
  ConsumerState<AddMeasurementSheet>
  createState() => _AddMeasurementSheetState();
}

class _AddMeasurementSheetState
    extends ConsumerState<AddMeasurementSheet> {
  late final TextEditingController
  _weightController;
  late final TextEditingController
  _neckController;
  late final TextEditingController
  _waistController;
  late final TextEditingController _hipController;
  late final TextEditingController
  _manualBodyFatController;
  late final TextEditingController
  _fallbackHeightController;
  late DateTime _selectedDate;
  bool _isAutoBodyFat = true;
  bool _isSubmitting = false;
  String? _errorText;

  bool get _isEditMode => widget.existing != null;

  @override
  void initState() {
    super.initState();
    final existing = widget.existing;
    _weightController = TextEditingController(
      text: existing?.weight.toString() ?? '',
    );
    _neckController = TextEditingController(
      text: existing?.neck?.toString() ?? '',
    );
    _waistController = TextEditingController(
      text: existing?.waist?.toString() ?? '',
    );
    _hipController = TextEditingController(
      text: existing?.hip?.toString() ?? '',
    );
    _manualBodyFatController =
        TextEditingController(
          text:
              existing?.bodyFatPercentage
                  ?.toString() ??
              '',
        );
    _fallbackHeightController =
        TextEditingController(
          text: existing?.height.toString() ?? '',
        );
    _selectedDate =
        existing?.date ?? DateTime.now();
    // Yeni ölçümde varsayılan OTOMATIK, düzenlemede kayıtlı değeri
    // koruma amacıyla varsayılan MANUEL başlar.
    _isAutoBodyFat = !_isEditMode;
  }

  @override
  void dispose() {
    _weightController.dispose();
    _neckController.dispose();
    _waistController.dispose();
    _hipController.dispose();
    _manualBodyFatController.dispose();
    _fallbackHeightController.dispose();
    super.dispose();
  }

  /// Boy artık normalde kullanıcıdan istenmiyor — en son ölçümden (ya da
  /// düzenleme modundaysa o ölçümün kendi boyundan) otomatik alınır.
  /// Hiç önceki ölçüm yoksa (nadir/eski hesap) fallback alana düşer.
  double? _resolveHeight(
    List<BodyMeasurementEntity> history,
  ) {
    if (_isEditMode)
      return widget.existing!.height;
    if (history.isNotEmpty)
      return history.first.height;
    return double.tryParse(
      _fallbackHeightController.text,
    );
  }

  double? _computeAutoBodyFat({
    required Gender gender,
    required double? height,
  }) {
    final neck = double.tryParse(
      _neckController.text,
    );
    final waist = double.tryParse(
      _waistController.text,
    );
    final hip = double.tryParse(
      _hipController.text,
    );
    if (height == null ||
        neck == null ||
        waist == null)
      return null;
    return BodyFatCalculator.calculate(
      gender: gender,
      heightCm: height,
      neckCm: neck,
      waistCm: waist,
      hipCm: gender == Gender.female ? hip : null,
    );
  }

  Future<void> _handleSave() async {
    final l10n = AppLocalizations.of(context);
    final user = ref
        .read(authControllerProvider)
        .valueOrNull;
    final history =
        ref
            .read(
              bodyMeasurementControllerProvider,
            )
            .valueOrNull ??
        [];

    final weight = double.tryParse(
      _weightController.text,
    );
    final height = _resolveHeight(history);

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
      final neck = double.tryParse(
        _neckController.text,
      );
      final waist = double.tryParse(
        _waistController.text,
      );
      final hip = double.tryParse(
        _hipController.text,
      );
      final bodyFat = _isAutoBodyFat
          ? _computeAutoBodyFat(
              gender:
                  user?.gender ?? Gender.other,
              height: height,
            )
          : double.tryParse(
              _manualBodyFatController.text,
            );

      final controller = ref.read(
        bodyMeasurementControllerProvider
            .notifier,
      );
      final success = _isEditMode
          ? await controller.updateMeasurement(
              id: widget.existing!.id,
              date: _selectedDate,
              weight: weight,
              height: height,
              neck: neck,
              waist: waist,
              hip: hip,
              bodyFatPercentage: bodyFat,
            )
          : await controller.addMeasurement(
              date: _selectedDate,
              weight: weight,
              height: height,
              neck: neck,
              waist: waist,
              hip: hip,
              bodyFatPercentage: bodyFat,
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
    final user = ref
        .watch(authControllerProvider)
        .valueOrNull;
    final history =
        ref
            .watch(
              bodyMeasurementControllerProvider,
            )
            .valueOrNull ??
        [];
    final isFemale =
        user?.gender == Gender.female;
    final resolvedHeight = _resolveHeight(
      history,
    );
    final showFallbackHeightField =
        !_isEditMode && history.isEmpty;

    final previewBodyFat = _isAutoBodyFat
        ? _computeAutoBodyFat(
            gender: user?.gender ?? Gender.other,
            height: resolvedHeight,
          )
        : double.tryParse(
            _manualBodyFatController.text,
          );

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
              _isEditMode
                  ? l10n.editMeasurementTitle
                  : l10n.addMeasurementTitle,
              style: Theme.of(
                context,
              ).textTheme.headlineMedium,
            ),
            if (!_isEditMode) ...[
              const SizedBox(
                height: AppSpacing.xs,
              ),
              Text(l10n.addMeasurementSubtitle),
            ],
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
            AppTextField(
              label: l10n.weightLabelKg,
              controller: _weightController,
              keyboardType:
                  const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
            ),
            if (showFallbackHeightField) ...[
              const SizedBox(
                height: AppSpacing.md,
              ),
              AppTextField(
                label: l10n.heightLabelCm,
                controller:
                    _fallbackHeightController,
                keyboardType:
                    TextInputType.number,
                onChanged: (_) => setState(() {}),
              ),
            ],
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: AppTextField(
                    label: l10n.neckLabelCm,
                    controller: _neckController,
                    keyboardType:
                        const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                    onChanged: (_) =>
                        setState(() {}),
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
                        const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                    onChanged: (_) =>
                        setState(() {}),
                  ),
                ),
              ],
            ),
            if (isFemale) ...[
              const SizedBox(
                height: AppSpacing.md,
              ),
              AppTextField(
                label: l10n.hipLabelCm,
                controller: _hipController,
                keyboardType:
                    const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                onChanged: (_) => setState(() {}),
              ),
            ],
            const SizedBox(height: AppSpacing.lg),
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    l10n.bodyFatLabel,
                    style: Theme.of(
                      context,
                    ).textTheme.labelSmall,
                  ),
                ),
                Text(
                  _isAutoBodyFat
                      ? l10n.autoCalculateBodyFatLabel
                      : l10n.manualBodyFatLabel,
                  style: Theme.of(
                    context,
                  ).textTheme.labelSmall,
                ),
                Switch(
                  value: _isAutoBodyFat,
                  onChanged: (value) => setState(
                    () => _isAutoBodyFat = value,
                  ),
                ),
              ],
            ),
            if (_isAutoBodyFat)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(
                  AppSpacing.md,
                ),
                decoration: BoxDecoration(
                  color: AppColors
                      .surfaceContainerLow,
                  borderRadius:
                      BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.calculate_outlined,
                      color: AppColors.primary,
                    ),
                    const SizedBox(
                      width: AppSpacing.sm,
                    ),
                    Expanded(
                      child: Text(
                        previewBodyFat != null
                            ? '${l10n.bodyFatCalculatedLabel}: ${previewBodyFat.toStringAsFixed(1)}%'
                            : l10n.insufficientDataForBodyFat,
                      ),
                    ),
                  ],
                ),
              )
            else
              AppTextField(
                label: l10n.bodyFatLabel,
                controller:
                    _manualBodyFatController,
                keyboardType:
                    const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
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
              label: _isEditMode
                  ? l10n.updateMeasurementButton
                  : l10n.saveMeasurementButton,
              isLoading: _isSubmitting,
              onPressed: _handleSave,
            ),
          ],
        ),
      ),
    );
  }
}
