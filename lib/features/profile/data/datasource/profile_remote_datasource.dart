// datasources/profile_remote_datasource.dart

import 'package:dio/dio.dart';

import '../../../../core/error/app_exception.dart';
import '../../../auth/data/models/user_dto.dart';

class ProfileRemoteDataSource {
  final Dio _dio;
  const ProfileRemoteDataSource(this._dio);

  /// ⚠️ Backend route'u '/user/update/' — SONUNDA SLASH VAR, atlanırsa 404.
  Future<UserDto> updateProfile({
    String? username,
    String? name,
    String? surname,
    String? phone,
    String? email,
    String? locationPreference,
    String? goal, // ⬅️ YENİ
    String? activityLevel, // ⬅️ YENİ
  }) async {
    try {
      final response = await _dio.put(
        '/user/update/',
        data: {
          if (username != null)
            'username': username,
          if (name != null) 'name': name,
          if (surname != null) 'surname': surname,
          if (phone != null) 'phone': phone,
          if (email != null) 'email': email,
          if (locationPreference != null)
            'locationPreference':
                locationPreference,
          if (goal != null)
            'goal': goal, // ⬅️ YENİ
          if (activityLevel != null)
            'activityLevel':
                activityLevel, // ⬅️ YENİ
        },
      );
      final data =
          response.data as Map<String, dynamic>;
      return UserDto.fromJson(
        data['user'] as Map<String, dynamic>,
      );
    } on DioException catch (error, stackTrace) {
      throw AppExceptionFactory.network(
        source:
            'ProfileRemoteDataSource - updateProfile',
        message:
            _extractMessage(error) ??
            'Profil güncellenemedi.',
        originalError: error,
        stackTrace: stackTrace,
      );
    } catch (error, stackTrace) {
      throw AppExceptionFactory.unexpected(
        source:
            'ProfileRemoteDataSource - updateProfile',
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
