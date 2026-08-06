import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gymplanner_mobile/core/error/result.dart';
import 'package:gymplanner_mobile/core/widgets/responsive_form_scaffold.dart';
import 'package:gymplanner_mobile/features/body_measurement/presentation/controller/body_measurement_controller.dart';
import 'package:gymplanner_mobile/features/profile/presentation/controller/edit_profile_controller.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/app_logger.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/labeled_dropdown.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../nutrition/presentation/providers/nutrition_providers.dart';
import '../../domain/entities/user_entity.dart';
import '../controllers/auth_controller.dart';
import '../controllers/signup_form_controller.dart';

class SignupStep2Page
    extends ConsumerStatefulWidget {
  const SignupStep2Page({super.key});

  @override
  ConsumerState<SignupStep2Page> createState() =>
      _SignupStep2PageState();
}

class _SignupStep2PageState
    extends ConsumerState<SignupStep2Page> {
  final _heightController =
      TextEditingController();
  final _weightController =
      TextEditingController();
  LocationPreference _selectedLocation =
      LocationPreference.gym;
  UserGoal _selectedGoal = UserGoal.maintain;
  ActivityLevel _selectedActivity =
      ActivityLevel.moderate;
  bool _isSubmitting = false;
  String? _errorText;

  @override
  void dispose() {
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  Future<void> _handleComplete() async {
    final l10n = AppLocalizations.of(context);
    final height = double.tryParse(
      _heightController.text,
    );
    final weight = double.tryParse(
      _weightController.text,
    );

    if (height == null || weight == null) {
      setState(
        () => _errorText =
            'Geçerli boy ve kilo değeri gir.',
      );
      return;
    }

    final formData = ref.read(
      signupFormControllerProvider,
    );
    if (formData.birthdate == null) {
      setState(
        () => _errorText =
            'Bir sorun oluştu, lütfen Adım 1\'e dön.',
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
      _errorText = null;
    });

    try {
      // 1) Hesabı oluştur (token otomatik kaydedilir).
      final user = await ref
          .read(authControllerProvider.notifier)
          .register(
            username: formData.username,
            email: formData.email,
            password: formData.password,
            confirmPassword: formData.password,
            name: formData.fullName
                .split(' ')
                .first,
            surname: formData.fullName
                .split(' ')
                .skip(1)
                .join(' '),
            phone: formData.phone,
            birthdate: formData.birthdate!,
            gender: formData.gender,
          );

      if (user == null) {
        if (!mounted) return;
        final error = ref
            .read(authControllerProvider)
            .error;
        setState(
          () => _errorText =
              error?.toString() ??
              'Kayıt başarısız.',
        );
        return;
      }

      // 2) İlk vücut ölçümünü kaydet (boy/kilo).
      await ref
          .read(
            bodyMeasurementControllerProvider
                .notifier,
          )
          .addMeasurement(
            weight: weight,
            height: height,
          );

      // 3) Ev/Salon, Hedef, Aktivite seviyesini profile yaz.
      await ref
          .read(
            editProfileControllerProvider
                .notifier,
          )
          .submit(
            locationPreference: _selectedLocation,
            goal: _selectedGoal,
            activityLevel: _selectedActivity,
          );

      // Local form state'i temizle.
      ref
          .read(
            signupFormControllerProvider.notifier,
          )
          .reset();

      // 4) Hesaplanan kalori hedefini çek ve kullanıcıya göster.
      if (!mounted) return;
      final targetResult = await ref
          .read(nutritionRepositoryProvider)
          .getTarget();
      final targetCalories = targetResult
          .valueOrNull
          ?.targetCalories;

      if (!mounted) return;

      if (targetCalories != null) {
        await showDialog<void>(
          context: context,
          barrierDismissible: false,
          builder: (dialogContext) => AlertDialog(
            title: Text(
              l10n.yourDailyCalorieTargetTitle,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '$targetCalories kcal',
                  style: Theme.of(
                    dialogContext,
                  ).textTheme.headlineLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: AppSpacing.md,
                ),
                Text(
                  l10n.calorieTargetSubtitle,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            actions: [
              FilledButton(
                onPressed: () => Navigator.of(
                  dialogContext,
                ).pop(),
                child: Text(l10n.continueButton),
              ),
            ],
          ),
        );
      }

      if (!mounted) return;
      context.go(AppRoutes.dashboard);
    } catch (error, stackTrace) {
      AppLogger.error(
        'SignupStep2Page - _handleComplete',
        error,
        stackTrace,
      );
      if (mounted) {
        setState(
          () => _errorText =
              'Bir hata oluştu: $error',
        );
      }
    } finally {
      if (mounted)
        setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return ResponsiveFormScaffold(
      appBar: AppBar(
        title: const Text('Kayıt Ol — Adım 2/2'),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          AppTextField(
            label: 'Boy (cm)',
            controller: _heightController,
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: AppSpacing.lg),
          AppTextField(
            label: 'Kilo (kg)',
            controller: _weightController,
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            l10n.locationPreferenceLabel,
            style: Theme.of(
              context,
            ).textTheme.labelSmall,
          ),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            children: [
              ChoiceChip(
                label: Text(l10n.locationHome),
                selected:
                    _selectedLocation ==
                    LocationPreference.home,
                onSelected: (_) => setState(
                  () => _selectedLocation =
                      LocationPreference.home,
                ),
              ),
              ChoiceChip(
                label: Text(l10n.locationGym),
                selected:
                    _selectedLocation ==
                    LocationPreference.gym,
                onSelected: (_) => setState(
                  () => _selectedLocation =
                      LocationPreference.gym,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          LabeledDropdown<UserGoal>(
            label: l10n.goalLabel,
            value: _selectedGoal,
            items: [
              DropdownMenuItem(
                value: UserGoal.loseWeight,
                child: Text(l10n.goalLoseWeight),
              ),
              DropdownMenuItem(
                value: UserGoal.gainMuscle,
                child: Text(l10n.goalGainMuscle),
              ),
              DropdownMenuItem(
                value: UserGoal.maintain,
                child: Text(l10n.goalMaintain),
              ),
              DropdownMenuItem(
                value: UserGoal.improveEndurance,
                child: Text(
                  l10n.goalImproveEndurance,
                ),
              ),
            ],
            onChanged: (value) {
              if (value != null)
                setState(
                  () => _selectedGoal = value,
                );
            },
          ),
          const SizedBox(height: AppSpacing.lg),
          LabeledDropdown<ActivityLevel>(
            label: l10n.activityLevelLabel,
            value: _selectedActivity,
            items: [
              DropdownMenuItem(
                value: ActivityLevel.sedentary,
                child: Text(
                  l10n.activityLevelSedentary,
                ),
              ),
              DropdownMenuItem(
                value: ActivityLevel.light,
                child: Text(
                  l10n.activityLevelLight,
                ),
              ),
              DropdownMenuItem(
                value: ActivityLevel.moderate,
                child: Text(
                  l10n.activityLevelModerate,
                ),
              ),
              DropdownMenuItem(
                value: ActivityLevel.active,
                child: Text(
                  l10n.activityLevelActive,
                ),
              ),
            ],
            onChanged: (value) {
              if (value != null)
                setState(
                  () => _selectedActivity = value,
                );
            },
          ),
          if (_errorText != null) ...[
            const SizedBox(height: AppSpacing.md),
            Text(
              _errorText!,
              style: const TextStyle(
                color: Colors.red,
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.xl),
          PrimaryButton(
            label: 'Kaydı Tamamla',
            isLoading: _isSubmitting,
            onPressed: _handleComplete,
          ),
        ],
      ),
    );
  }
}
