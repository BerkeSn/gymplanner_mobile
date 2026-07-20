// usecases/login_usecase.dart

import 'package:gymplanner_mobile/core/error/app_exception.dart';

import '../../../../core/error/result.dart';
import '../entities/auth_session.dart';
import '../repositories/auth_repository.dart';

/// İnce bir usecase gibi görünse de, business rule burada büyüyecek yer:
/// örn. ileride "5 başarısız denemeden sonra kilitle" gibi bir kural
/// eklenirse repository'ye değil, buraya eklenir.
/// 
class LoginUseCase {
  final AuthRepository _repository;
  const LoginUseCase(this._repository);

  Future<Result<AuthSession>> call({
    required String loginInput,
    required String password,
  }) async {
    try {
      if (loginInput.trim().isEmpty ||
          password.isEmpty) {
        return Failure(
          AppExceptionFactory.validation(
            source: 'LoginUseCase - call',
            message:
                'Kullanıcı adı/e-posta ve şifre boş bırakılamaz.',
          ),
        );
      }
      return await _repository.login(
        loginInput: loginInput.trim(),
        password: password,
      );
    } catch (error, stackTrace) {
      return Failure(
        AppExceptionFactory.unexpected(
          source: 'LoginUseCase - call',
          error: error,
          stackTrace: stackTrace,
        ),
      );
    }
  }
}
