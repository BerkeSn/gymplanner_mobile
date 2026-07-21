import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/app_logger.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/primary_button.dart';
import '../controllers/workout_programs_controller.dart';

/// standardized_program_creator_modal.html temel alınmıştır.
/// NOT: Mockup'taki "Days/Week" ve "Training Goal" seçicileri backend
/// modelinde karşılığı olmadığı için BİLİNÇLİ OLARAK bu sürümde yok —
/// eklenirse WorkoutRoutine modeline yeni alan gerekir (Faz sonrası karar).
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
  bool _isSubmitting = false;
  String? _errorText;

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
              style: Theme.of(
                context,
              ).textTheme.headlineMedium,
            ),
            const SizedBox(height: AppSpacing.lg),
            AppTextField(
              label: 'Program Adı',
              controller: _nameController,
            ),
            const SizedBox(height: AppSpacing.lg),
            AppTextField(
              label: 'Açıklama (opsiyonel)',
              controller: _descriptionController,
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
              label: 'Oluştur',
              isLoading: _isSubmitting,
              onPressed: _handleCreate,
            ),
          ],
        ),
      ),
    );
  }
}
