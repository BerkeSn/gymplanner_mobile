// repositories/auth_repository_impl.dart

import 'package:dio/dio.dart';
import 'package:gymplanner_mobile/core/utils/app_logger.dart';

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

      final userDto = await _remoteDataSource
          .getProfile();
      return userDto.toEntity();
    } on AppException catch (error) {
      // Token süresi dolmuş/geçersizse (401) temizle — böylece kullanıcı
      // bir daha login olduğunda eski, bozuk token cihazda kalmaz.
      final statusCode =
          error.originalError is DioException
          ? (error.originalError as DioException)
                .response
                ?.statusCode
          : null;
      if (statusCode == 401) {
        await _tokenStorage.clearToken();
      }
      AppLogger.error(
        'AuthRepositoryImpl - getCachedSession',
        error,
      );
      return null;
    } catch (error, stackTrace) {
      // Network hatası (ör. Render cold start) gibi geçici durumlarda
      // token'a DOKUNMA — kullanıcı gereksiz yere tekrar login olmasın,
      // sadece bu seferlik oturum açılmamış gibi davran.
      AppLogger.error(
        'AuthRepositoryImpl - getCachedSession',
        error,
        stackTrace,
      );
      return null;
    }
  }
}
