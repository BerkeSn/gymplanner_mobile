// datasources/auth_remote_datasource.dart

import 'package:dio/dio.dart';
import 'package:gymplanner_mobile/core/error/app_exception.dart';

import '../models/user_dto.dart';

class AuthRemoteDataSource {
  final Dio _dio;
  const AuthRemoteDataSource(this._dio);

  /// Backend: POST /api/user/login  body: { loginInput, password }
  /// Dönüş: { success, token, user }
  Future<(String token, UserDto user)> login({
    required String loginInput,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        '/user/login',
        data: {
          'loginInput': loginInput,
          'password': password,
        },
      );

      final data =
          response.data as Map<String, dynamic>;
      final token = data['token'] as String;
      final user = UserDto.fromJson(
        data['user'] as Map<String, dynamic>,
      );
      return (token, user);
    } on DioException catch (error, stackTrace) {
      throw AppExceptionFactory.network(
        source: 'AuthRemoteDataSource - login',
        message:
            _extractMessage(error) ??
            'Giriş başarısız.',
        originalError: error,
        stackTrace: stackTrace,
      );
    } catch (error, stackTrace) {
      throw AppExceptionFactory.unexpected(
        source: 'AuthRemoteDataSource - login',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  /// Backend: POST /api/user/register
  /// body: { username, email, password, name, surname, phone, birthdate, gender }
  /// Dönüş: { message, user, token }
  Future<(String token, UserDto user)> register({
    required String username,
    required String email,
    required String password,
    required String name,
    required String surname,
    String? phone,
    required DateTime birthdate,
    required String gender,
  }) async {
    try {
      final response = await _dio.post(
        '/user/register',
        data: {
          'username': username,
          'email': email,
          'password': password,
          'name': name,
          'surname': surname,
          if (phone != null && phone.isNotEmpty)
            'phone': phone,
          'birthdate': birthdate
              .toIso8601String()
              .split('T')
              .first,
          'gender': gender,
        },
      );

      final data =
          response.data as Map<String, dynamic>;
      final token = data['token'] as String;
      final user = UserDto.fromJson(
        data['user'] as Map<String, dynamic>,
      );
      return (token, user);
    } on DioException catch (error, stackTrace) {
      throw AppExceptionFactory.network(
        source: 'AuthRemoteDataSource - register',
        message:
            _extractMessage(error) ??
            'Kayıt başarısız.',
        originalError: error,
        stackTrace: stackTrace,
      );
    } catch (error, stackTrace) {
      throw AppExceptionFactory.unexpected(
        source: 'AuthRemoteDataSource - register',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  String? _extractMessage(DioException error) {
    final data = error.response?.data;
    if (data is Map<String, dynamic>) {
      return (data['message'] ?? data['error'])
          ?.toString();
    }
    return null;
  }
}
