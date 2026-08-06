import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gymplanner_mobile/core/widgets/responsive_form_scaffold.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../domain/entities/user_entity.dart';
import '../controllers/signup_form_controller.dart';

class SignupStep1Page
    extends ConsumerStatefulWidget {
  const SignupStep1Page({super.key});

  @override
  ConsumerState<SignupStep1Page> createState() =>
      _SignupStep1PageState();
}

class _SignupStep1PageState
    extends ConsumerState<SignupStep1Page> {
  final _fullNameController =
      TextEditingController();
  final _usernameController =
      TextEditingController();
  final _emailController =
      TextEditingController();
  final _phoneController =
      TextEditingController();
  final _passwordController =
      TextEditingController();
  final _confirmPasswordController =
      TextEditingController();
  Gender _selectedGender = Gender.male;
  DateTime? _birthdate;
  String? _validationError;

  bool _obscurePassword = true; // ⬅️ YENİ
  bool _obscureConfirmPassword = true; // ⬅️ YENİ

  @override
  void dispose() {
    _fullNameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  /// Basit e-posta format kontrolü. Sunucu tarafı (Sequelize `isEmail`
  /// validator) zaten kesin doğrulamayı yapıyor, bu sadece erken UX geri
  /// bildirimi içindir — güvenlik sınırı olarak KULLANILMAMALI.
  bool _isValidEmail(String value) {
    final regex = RegExp(
      r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
    );
    return regex.hasMatch(value.trim());
  }

  Future<void> _pickBirthdate() async {
    try {
      final picked = await showDatePicker(
        context: context,
        initialDate: DateTime(2000, 1, 1),
        firstDate: DateTime(1930),
        lastDate: DateTime.now(),
      );
      if (picked != null) {
        setState(() => _birthdate = picked);
      }
    } catch (error, stackTrace) {
      debugPrint(
        '[SignupStep1Page - _pickBirthdate]: $error\n$stackTrace',
      );
    }
  }

  void _handleNext() {
    try {
      if (_fullNameController.text
              .trim()
              .isEmpty ||
          _usernameController.text
              .trim()
              .isEmpty ||
          _emailController.text.trim().isEmpty ||
          _passwordController.text.isEmpty) {
        setState(
          () => _validationError =
              'Lütfen zorunlu alanları doldur.',
        );
        return;
      }
      if (!_isValidEmail(_emailController.text)) {
        setState(
          () => _validationError =
              'Geçerli bir e-posta adresi gir.',
        );
        return;
      }
      if (_passwordController.text !=
          _confirmPasswordController.text) {
        setState(
          () => _validationError =
              'Şifreler eşleşmiyor.',
        );
        return;
      }
      if (_birthdate == null) {
        setState(
          () => _validationError =
              'Lütfen doğum tarihini seç.',
        );
        return;
      }

      ref
          .read(
            signupFormControllerProvider.notifier,
          )
          .updateStep1(
            fullName: _fullNameController.text,
            username: _usernameController.text,
            email: _emailController.text,
            phone: _phoneController.text,
            gender: _selectedGender,
            password: _passwordController.text,
            birthdate: _birthdate!,
          );

      debugPrint(
        '🔵 [Step1] Kaydedilen birthdate: ${ref.read(signupFormControllerProvider).birthdate}',
      );

      context.push(AppRoutes.signupStep2);
    } catch (error, stackTrace) {
      debugPrint(
        '[SignupStep1Page - _handleNext]: $error\n$stackTrace',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveFormScaffold(
      appBar: AppBar(
        title: const Text('Kayıt Ol — Adım 1/2'),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          AppTextField(
            label: 'Ad Soyad',
            controller: _fullNameController,
          ),
          const SizedBox(height: AppSpacing.lg),
          AppTextField(
            label: 'Username',
            controller: _usernameController,
          ),
          const SizedBox(height: AppSpacing.lg),
          AppTextField(
            label: 'E-posta',
            controller: _emailController,
            keyboardType:
                TextInputType.emailAddress,
          ),
          const SizedBox(height: AppSpacing.lg),
          AppTextField(
            label: 'Telefon Numarası',
            controller: _phoneController,
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Cinsiyet',
            style: AppTextStyles.labelSmall,
          ),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.md,
            children: Gender.values.map((gender) {
              return ChoiceChip(
                label: Text(gender.name),
                selected:
                    _selectedGender == gender,
                onSelected: (_) => setState(
                  () => _selectedGender = gender,
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: AppSpacing.lg),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(
              _birthdate == null
                  ? 'Doğum Tarihi Seç'
                  : '${_birthdate!.day}/${_birthdate!.month}/${_birthdate!.year}',
            ),
            trailing: const Icon(
              Icons.calendar_today,
            ),
            onTap: _pickBirthdate,
          ),
          const SizedBox(height: AppSpacing.lg),
          AppTextField(
            label: 'Şifre',
            controller: _passwordController,
            obscureText: _obscurePassword,
            suffixIcon: IconButton(
              // ⬅️ YENİ
              icon: Icon(
                _obscurePassword
                    ? Icons.visibility
                    : Icons.visibility_off,
              ),
              onPressed: () => setState(
                () => _obscurePassword =
                    !_obscurePassword,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          AppTextField(
            label: 'Şifre Tekrar',
            controller:
                _confirmPasswordController,
            obscureText: _obscureConfirmPassword,
            suffixIcon: IconButton(
              // ⬅️ YENİ
              icon: Icon(
                _obscureConfirmPassword
                    ? Icons.visibility
                    : Icons.visibility_off,
              ),
              onPressed: () => setState(
                () => _obscureConfirmPassword =
                    !_obscureConfirmPassword,
              ),
            ),
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
            label: 'Devam Et',
            onPressed: _handleNext,
          ),
        ],
      ),
    );
  }
}
