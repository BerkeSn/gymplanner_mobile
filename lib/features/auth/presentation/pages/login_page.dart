// presentation/pages/login_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gymplanner_mobile/core/error/app_exception.dart';
import 'package:gymplanner_mobile/core/utils/app_logger.dart';
import 'package:gymplanner_mobile/core/widgets/responsive_form_scaffold.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../l10n/app_localizations.dart';
import '../controllers/auth_controller.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() =>
      _LoginPageState();
}

class _LoginPageState
    extends ConsumerState<LoginPage> {
  final _loginController =
      TextEditingController();
  final _passwordController =
      TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _loginController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    try {
      final success = await ref
          .read(authControllerProvider.notifier)
          .login(
            loginInput: _loginController.text,
            password: _passwordController.text,
          );

      if (!mounted) return;

      if (success) {
        context.go(AppRoutes.dashboard);
      } else {
        final error = ref
            .read(authControllerProvider)
            .error;
        final message = error is AppException
            ? error.userMessage
            : (error?.toString() ??
                  'Giriş başarısız.');

        if (error != null) {
          AppLogger.error(
            'LoginPage - _handleLogin',
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
        '[LoginPage - _handleLogin]: $error\n$stackTrace',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(
      authControllerProvider,
    );
    final l10n = AppLocalizations.of(context);

    return ResponsiveFormScaffold(
      // ⬅️ DEĞİŞTİ: Scaffold+SafeArea+Padding yerine
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSpacing.xl),
          Text(
            l10n.loginTitle,
            style: AppTextStyles.headlineLarge,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            l10n.loginSubtitle,
            style: AppTextStyles.bodyMedium,
          ),
          const SizedBox(height: AppSpacing.xl),
          AppTextField(
            label: l10n.emailOrUsername,
            controller: _loginController,
            keyboardType:
                TextInputType.emailAddress,
          ),
          const SizedBox(height: AppSpacing.lg),
          AppTextField(
            label: l10n.password,
            controller: _passwordController,
            obscureText: _obscurePassword,
            suffixIcon: IconButton(
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
          const SizedBox(height: AppSpacing.xl),
          PrimaryButton(
            label: l10n.loginTitle,
            isLoading: authState.isLoading,
            onPressed: _handleLogin,
          ),
          const SizedBox(height: AppSpacing.lg),
          Center(
            child: TextButton(
              onPressed: () => context.push(
                AppRoutes.signupStep1,
              ),
              child: const Text(
                'Hesabın yok mu? Kayıt Ol',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
