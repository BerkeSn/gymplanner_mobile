// datasources/friend_remote_datasource.dart

import 'package:dio/dio.dart';

import '../../../../core/error/app_exception.dart';
import '../models/friendship_request_dto.dart';
import '../models/user_summary_dto.dart';

class FriendRemoteDataSource {
  final Dio _dio;
  const FriendRemoteDataSource(this._dio);

  Future<List<UserSummaryDto>> searchUsers(
    String query,
  ) async {
    try {
      final response = await _dio.get(
        '/user/searchUsers',
        queryParameters: {'query': query},
      );
      final data =
          response.data as Map<String, dynamic>;
      final list = data['users'] as List<dynamic>;
      return list
          .map(
            (json) => UserSummaryDto.fromJson(
              json as Map<String, dynamic>,
            ),
          )
          .toList();
    } on DioException catch (error, stackTrace) {
      throw AppExceptionFactory.network(
        source:
            'FriendRemoteDataSource - searchUsers',
        message:
            _extractMessage(error) ??
            'Arama başarısız.',
        originalError: error,
        stackTrace: stackTrace,
      );
    } catch (error, stackTrace) {
      throw AppExceptionFactory.unexpected(
        source:
            'FriendRemoteDataSource - searchUsers',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> sendFriendRequest(
    int receiverId,
  ) async {
    try {
      await _dio.post(
        '/user/addFriend/$receiverId',
      );
    } on DioException catch (error, stackTrace) {
      throw AppExceptionFactory.network(
        source:
            'FriendRemoteDataSource - sendFriendRequest',
        message:
            _extractMessage(error) ??
            'İstek gönderilemedi.',
        originalError: error,
        stackTrace: stackTrace,
      );
    } catch (error, stackTrace) {
      throw AppExceptionFactory.unexpected(
        source:
            'FriendRemoteDataSource - sendFriendRequest',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  Future<List<FriendshipRequestDto>>
  getPendingRequests() async {
    try {
      final response = await _dio.get(
        '/user/getPendingRequests',
      );
      final data =
          response.data as Map<String, dynamic>;
      final list =
          data['requests'] as List<dynamic>;
      return list
          .map(
            (json) =>
                FriendshipRequestDto.fromJson(
                  json as Map<String, dynamic>,
                ),
          )
          .toList();
    } on DioException catch (error, stackTrace) {
      throw AppExceptionFactory.network(
        source:
            'FriendRemoteDataSource - getPendingRequests',
        message:
            _extractMessage(error) ??
            'İstekler alınamadı.',
        originalError: error,
        stackTrace: stackTrace,
      );
    } catch (error, stackTrace) {
      throw AppExceptionFactory.unexpected(
        source:
            'FriendRemoteDataSource - getPendingRequests',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> respondToRequest({
    required int friendshipId,
    required bool accept,
  }) async {
    try {
      await _dio.post(
        '/user/respondToRequest/$friendshipId',
        data: {
          'status': accept
              ? 'accepted'
              : 'rejected',
        },
      );
    } on DioException catch (error, stackTrace) {
      throw AppExceptionFactory.network(
        source:
            'FriendRemoteDataSource - respondToRequest',
        message:
            _extractMessage(error) ??
            'İşlem gerçekleştirilemedi.',
        originalError: error,
        stackTrace: stackTrace,
      );
    } catch (error, stackTrace) {
      throw AppExceptionFactory.unexpected(
        source:
            'FriendRemoteDataSource - respondToRequest',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  Future<List<UserSummaryDto>>
  getMyFriends() async {
    try {
      final response = await _dio.get(
        '/user/getMyFriends',
      );
      final data =
          response.data as Map<String, dynamic>;
      final list =
          data['friends'] as List<dynamic>;
      return list
          .map(
            (json) => UserSummaryDto.fromJson(
              json as Map<String, dynamic>,
            ),
          )
          .toList();
    } on DioException catch (error, stackTrace) {
      throw AppExceptionFactory.network(
        source:
            'FriendRemoteDataSource - getMyFriends',
        message:
            _extractMessage(error) ??
            'Arkadaşlar alınamadı.',
        originalError: error,
        stackTrace: stackTrace,
      );
    } catch (error, stackTrace) {
      throw AppExceptionFactory.unexpected(
        source:
            'FriendRemoteDataSource - getMyFriends',
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
