// usecases/register_usecase.dart

import 'package:gymplanner_mobile/core/error/app_exception.dart';

import '../../../../core/error/result.dart';
import '../entities/auth_session.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository _repository;
  const RegisterUseCase(this._repository);

  Future<Result<AuthSession>> call({
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
    try {
      if (password != confirmPassword) {
        return Failure(
          AppExceptionFactory.validation(
            source: 'RegisterUseCase - call',
            message: 'Şifreler eşleşmiyor.',
          ),
        );
      }
      if (password.length < 6) {
        return Failure(
          AppExceptionFactory.validation(
            source: 'RegisterUseCase - call',
            message:
                'Şifre en az 6 karakter olmalı.',
          ),
        );
      }
      return await _repository.register(
        username: username.trim(),
        email: email.trim(),
        password: password,
        name: name.trim(),
        surname: surname.trim(),
        phone: phone?.trim(),
        birthdate: birthdate,
        gender: gender,
      );
    } catch (error, stackTrace) {
      return Failure(
        AppExceptionFactory.unexpected(
          source: 'RegisterUseCase - call',
          error: error,
          stackTrace: stackTrace,
        ),
      );
    }
  }
}
