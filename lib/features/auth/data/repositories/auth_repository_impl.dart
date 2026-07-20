// repositories/auth_repository_impl.dart

import '../../../../core/error/app_exception.dart';
import '../../../../core/error/result.dart';
import '../../../../core/storage/secure_token_storage.dart';
import '../../domain/entities/auth_session.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl
    implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final SecureTokenStorage _tokenStorage;

  const AuthRepositoryImpl(
    this._remoteDataSource,
    this._tokenStorage,
  );

  @override
  Future<Result<AuthSession>> login({
    required String loginInput,
    required String password,
  }) async {
    try {
      final (
        token,
        userDto,
      ) = await _remoteDataSource.login(
        loginInput: loginInput,
        password: password,
      );
      await _tokenStorage.saveToken(token);
      return Success(
        AuthSession(
          token: token,
          user: userDto.toEntity(),
        ),
      );
    } on AppException catch (error) {
      return Failure(error);
    } catch (error, stackTrace) {
      return Failure(
        AppExceptionFactory.unexpected(
          source: 'AuthRepositoryImpl - login',
          error: error,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  @override
  Future<Result<AuthSession>> register({
    required String username,
    required String email,
    required String password,
    required String name,
    required String surname,
    String? phone,
    required DateTime birthdate,
    required Gender gender,
  }) async {
    try {
      final (
        token,
        userDto,
      ) = await _remoteDataSource.register(
        username: username,
        email: email,
        password: password,
        name: name,
        surname: surname,
        phone: phone,
        birthdate: birthdate,
        gender: gender.apiValue,
      );
      await _tokenStorage.saveToken(token);
      return Success(
        AuthSession(
          token: token,
          user: userDto.toEntity(),
        ),
      );
    } on AppException catch (error) {
      return Failure(error);
    } catch (error, stackTrace) {
      return Failure(
        AppExceptionFactory.unexpected(
          source: 'AuthRepositoryImpl - register',
          error: error,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _tokenStorage.clearToken();
    } catch (error, stackTrace) {
      throw AppExceptionFactory.unexpected(
        source: 'AuthRepositoryImpl - logout',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  @override
  Future<UserEntity?> getCachedSession() async {
    try {
      final token = await _tokenStorage
          .readToken();
      if (token == null) return null;
      // Not: Faz 1'de sadece token varlığını kontrol ediyoruz.
      // Faz 2'de bu noktaya bir /getProfile çağrısı ekleyip
      // token'ın hâlâ geçerli olduğunu (401 değil) doğrulayacağız.
      return null; // Şimdilik: token varsa SplashPage login'e değil
      // home'a yönlendirmek için sadece token varlığı yeterli.
    } catch (error, stackTrace) {
      throw AppExceptionFactory.unexpected(
        source:
            'AuthRepositoryImpl - getCachedSession',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }
}
