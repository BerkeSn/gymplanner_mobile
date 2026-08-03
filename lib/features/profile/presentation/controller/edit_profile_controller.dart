// presentation/controllers/edit_profile_controller.dart

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/error/result.dart';
import '../../../../core/utils/app_logger.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../providers/profile_providers.dart';

part 'edit_profile_controller.g.dart';

@riverpod
class EditProfileController
    extends _$EditProfileController {
  @override
  FutureOr<void> build() {}

  /// Başarılıysa true döner VE AuthController'ı taze veriyle günceller —
  /// böylece profil sayfası ile diğer ekranlardaki (ör. dashboard selamlama)
  /// kullanıcı adı otomatik senkron kalır, ayrı bir refresh çağrısı gerekmez.
  Future<bool> submit({
    String? username,
    String? name,
    String? surname,
    String? phone,
    String? email,
    LocationPreference? locationPreference,
    UserGoal? goal,
    ActivityLevel? activityLevel,
  }) async {
    state = const AsyncLoading();
    try {
      final repository = ref.read(
        profileRepositoryProvider,
      );
      final result = await repository
          .updateProfile(
            username: username,
            name: name,
            surname: surname,
            phone: phone,
            email: email,
            locationPreference:
                locationPreference,
            goal: goal,
            activityLevel: activityLevel,
          );

      if (result is Failure<UserEntity>) {
        state = AsyncError(
          result.exception,
          StackTrace.current,
        );
        return false;
      }

      final updatedUser =
          (result as Success<UserEntity>).data;
      ref
          .read(authControllerProvider.notifier)
          .state = AsyncData(
        updatedUser,
      );
      state = const AsyncData(null);
      return true;
    } catch (error, stackTrace) {
      AppLogger.error(
        'EditProfileController - submit',
        error,
        stackTrace,
      );
      state = AsyncError(error, stackTrace);
      return false;
    }
  }
}
