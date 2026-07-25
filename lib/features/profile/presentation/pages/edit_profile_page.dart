import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymplanner_mobile/features/profile/presentation/controller/edit_profile_controller.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/app_logger.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';

class EditProfilePage
    extends ConsumerStatefulWidget {
  const EditProfilePage({super.key});

  @override
  ConsumerState<EditProfilePage> createState() =>
      _EditProfilePageState();
}

class _EditProfilePageState
    extends ConsumerState<EditProfilePage> {
  late final TextEditingController
  _nameController;
  late final TextEditingController
  _surnameController;
  late final TextEditingController
  _usernameController;
  late final TextEditingController
  _emailController;
  late final TextEditingController
  _phoneController;
  late LocationPreference _selectedLocation;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    final user = ref
        .read(authControllerProvider)
        .valueOrNull;
    _nameController = TextEditingController(
      text: user?.name ?? '',
    );
    _surnameController = TextEditingController(
      text: user?.surname ?? '',
    );
    _usernameController = TextEditingController(
      text: user?.username ?? '',
    );
    _emailController = TextEditingController(
      text: user?.email ?? '',
    );
    _phoneController = TextEditingController(
      text: user?.phone ?? '',
    );
    _selectedLocation =
        user?.locationPreference ??
        LocationPreference.gym;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    final l10n = AppLocalizations.of(context);
    setState(() => _errorText = null);

    try {
      final success = await ref
          .read(
            editProfileControllerProvider
                .notifier,
          )
          .submit(
            name: _nameController.text.trim(),
            surname: _surnameController.text
                .trim(),
            username: _usernameController.text
                .trim(),
            email: _emailController.text.trim(),
            phone: _phoneController.text.trim(),
            locationPreference: _selectedLocation,
          );

      if (!mounted) return;

      if (success) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(
          SnackBar(
            content: Text(
              l10n.profileUpdateSuccess,
            ),
          ),
        );
        Navigator.of(context).pop();
      } else {
        setState(
          () => _errorText =
              l10n.profileUpdateError,
        );
      }
    } catch (error, stackTrace) {
      AppLogger.error(
        'EditProfilePage - _handleSave',
        error,
        stackTrace,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isSubmitting = ref
        .watch(editProfileControllerProvider)
        .isLoading;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.editProfileTitle),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(
            AppSpacing.containerMargin,
          ),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              AppTextField(
                label: l10n.firstNameLabel,
                controller: _nameController,
              ),
              const SizedBox(
                height: AppSpacing.lg,
              ),
              AppTextField(
                label: l10n.lastNameLabel,
                controller: _surnameController,
              ),
              const SizedBox(
                height: AppSpacing.lg,
              ),
              AppTextField(
                label: l10n.usernameLabel,
                controller: _usernameController,
              ),
              const SizedBox(
                height: AppSpacing.lg,
              ),
              AppTextField(
                label: l10n.emailLabel,
                controller: _emailController,
                keyboardType:
                    TextInputType.emailAddress,
              ),
              const SizedBox(
                height: AppSpacing.lg,
              ),
              AppTextField(
                label: l10n.phoneLabel,
                controller: _phoneController,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(
                height: AppSpacing.lg,
              ),
              Text(
                l10n.locationPreferenceLabel,
                style: Theme.of(
                  context,
                ).textTheme.labelSmall,
              ),
              const SizedBox(
                height: AppSpacing.sm,
              ),
              Wrap(
                spacing: AppSpacing.sm,
                children: [
                  ChoiceChip(
                    label: Text(
                      l10n.locationHome,
                    ),
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
              const SizedBox(
                height: AppSpacing.xl,
              ),
              PrimaryButton(
                label: l10n.saveChangesButton,
                isLoading: isSubmitting,
                onPressed: _handleSave,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
