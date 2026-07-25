// presentation/controllers/auth_controller.dart

import 'package:gymplanner_mobile/core/utils/app_logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/error/result.dart';
import '../../domain/entities/user_entity.dart';
import '../providers/auth_providers.dart';

part 'auth_controller.g.dart';

@Riverpod(keepAlive: true)
class AuthController extends _$AuthController {
  @override
  FutureOr<UserEntity?> build() async {
    // Uygulama açılışında çağrılır — SplashPage bunu tetikler.
    try {
      final repository = ref.watch(
        authRepositoryProvider,
      );
      return await repository.getCachedSession();
    } catch (error, stackTrace) {
      // Cache okunamazsa kullanıcıyı login'e yönlendirmek için null dön,
      // uygulamayı çökertme.
      // ignore: avoid_print
      print(
        '[AuthController - build]: $error\n$stackTrace',
      );
      return null;
    }
  }

  Future<bool> login({
    required String loginInput,
    required String password,
  }) async {
    state = const AsyncLoading();
    try {
      final useCase = ref.read(
        loginUseCaseProvider,
      );
      final result = await useCase.call(
        loginInput: loginInput,
        password: password,
      );

      switch (result) {
        case Success(data: final session):
          state = AsyncData(session.user);
          return true;
        case Failure(exception: final exception):
          state = AsyncError(
            exception,
            exception.stackTrace ??
                StackTrace.current,
          );
          return false;
      }
    } catch (error, stackTrace) {
      state = AsyncError(
        Exception(
          '[AuthController - login]: ${error.toString()}',
        ),
        stackTrace,
      );
      return false;
    }
  }

  Future<UserEntity?> register({
    required String username,
    required String email,
    required String password,
    required String confirmPassword,
    required String name,
    required String surname,
    String? phone,
    required DateTime birthdate,
    required Gender gender,
  }) async {
    state = const AsyncLoading();
    try {
      final useCase = ref.read(
        registerUseCaseProvider,
      );
      final result = await useCase.call(
        username: username,
        email: email,
        password: password,
        confirmPassword: confirmPassword,
        name: name,
        surname: surname,
        phone: phone,
        birthdate: birthdate,
        gender: gender,
      );

      switch (result) {
        case Success(data: final session):
          state = AsyncData(session.user);
          return session.user;
        case Failure(exception: final exception):
          state = AsyncError(
            exception,
            exception.stackTrace ??
                StackTrace.current,
          );
          return null;
      }
    } catch (error, stackTrace) {
      state = AsyncError(
        Exception(
          '[AuthController - register]: ${error.toString()}',
        ),
        stackTrace,
      );
      return null;
    }
  }

  Future<void> logout() async {
    try {
      final repository = ref.read(
        authRepositoryProvider,
      );
      await repository.logout();
      state = const AsyncData(null);
    } catch (error, stackTrace) {
      AppLogger.error(
        'AuthController - logout',
        error,
        stackTrace,
      );
      // Token silinemese bile UI'ı login'e döndür — kullanıcı sıkışıp kalmasın.
      state = const AsyncData(null);
    }
  }

}
