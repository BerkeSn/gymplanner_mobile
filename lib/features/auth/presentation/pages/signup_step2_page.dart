// presentation/pages/signup_step2_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gymplanner_mobile/core/error/app_exception.dart';
import 'package:gymplanner_mobile/core/utils/app_logger.dart';
import 'package:gymplanner_mobile/core/widgets/responsive_form_scaffold.dart';
import 'package:gymplanner_mobile/features/body_measurement/presentation/controller/body_measurement_controller.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/primary_button.dart';
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
  String? _validationError;

  @override
  void dispose() {
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  Future<void> _handleComplete() async {
    try {
      final height = double.tryParse(
        _heightController.text,
      );
      final weight = double.tryParse(
        _weightController.text,
      );

      if (height == null || weight == null) {
        setState(
          () => _validationError =
              'Geçerli boy ve kilo değeri gir.',
        );
        return;
      }

      final formData = ref.read(
        signupFormControllerProvider,
      );
      debugPrint(
        '🟢 [Step2] Okunan birthdate: ${formData.birthdate}',
      );
      if (formData.birthdate == null) {
        setState(
          () => _validationError =
              'Bir sorun oluştu, lütfen Adım 1\'e dön.',
        );
        return;
      }

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

      if (!mounted) return;

      if (user != null) {
        // TODO(faz4) KAPANDI: height/weight artık ilk ölçüm kaydı olarak
        // backend'e gönderiliyor.
        final height = double.tryParse(
          _heightController.text,
        );
        final weight = double.tryParse(
          _weightController.text,
        );
        if (height != null && weight != null) {
          await ref
              .read(
                bodyMeasurementControllerProvider
                    .notifier,
              )
              .addMeasurement(
                weight: weight,
                height: height,
              );
        }

        ref
            .read(
              signupFormControllerProvider
                  .notifier,
            )
            .reset();
        if (mounted)
          context.go(AppRoutes.dashboard);
      } else {
        final error = ref
            .read(authControllerProvider)
            .error;
        final message = error is AppException
            ? error.userMessage
            : (error?.toString() ??
                  'Kayıt başarısız.');

        if (error != null) {
          AppLogger.error(
            'SignupStep2Page - _handleComplete',
            error,
          );
        }

        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(
            SnackBar(content: Text(message)),
          );
        }
      }
    } catch (error, stackTrace) {
      debugPrint(
        '[SignupStep2Page - _handleComplete]: $error\n$stackTrace',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
          if (_validationError != null) ...[
            const SizedBox(height: AppSpacing.md),
            Text(
              _validationError!,
              style: const TextStyle(
                color: Colors.red,
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.xl),
          PrimaryButton(
            label: 'Kaydı Tamamla',
            onPressed: _handleComplete,
          ),
        ],
      ),
    );
  }
}
