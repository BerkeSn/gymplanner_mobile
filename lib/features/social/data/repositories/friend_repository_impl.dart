// repositories/friend_repository_impl.dart

import 'package:gymplanner_mobile/features/social/data/datasource/friend_remote_datasource.dart';
import 'package:gymplanner_mobile/features/social/domain/entites/friendship_request_entity.dart';
import 'package:gymplanner_mobile/features/social/domain/entites/user_summary_entity.dart';

import '../../../../core/error/app_exception.dart';
import '../../../../core/error/result.dart';
import '../../domain/repositories/friend_repository.dart';

class FriendRepositoryImpl
    implements FriendRepository {
  final FriendRemoteDataSource _remoteDataSource;
  const FriendRepositoryImpl(
    this._remoteDataSource,
  );

  @override
  Future<Result<List<UserSummaryEntity>>>
  searchUsers(String query) async {
    try {
      final dtos = await _remoteDataSource
          .searchUsers(query);
      return Success(
        dtos
            .map((dto) => dto.toEntity())
            .toList(),
      );
    } on AppException catch (error) {
      return Failure(error);
    } catch (error, stackTrace) {
      return Failure(
        AppExceptionFactory.unexpected(
          source:
              'FriendRepositoryImpl - searchUsers',
          error: error,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  @override
  Future<Result<void>> sendFriendRequest(
    int receiverId,
  ) async {
    try {
      await _remoteDataSource.sendFriendRequest(
        receiverId,
      );
      return const Success(null);
    } on AppException catch (error) {
      return Failure(error);
    } catch (error, stackTrace) {
      return Failure(
        AppExceptionFactory.unexpected(
          source:
              'FriendRepositoryImpl - sendFriendRequest',
          error: error,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  @override
  Future<Result<List<FriendshipRequestEntity>>>
  getPendingRequests() async {
    try {
      final dtos = await _remoteDataSource
          .getPendingRequests();
      return Success(
        dtos
            .map((dto) => dto.toEntity())
            .toList(),
      );
    } on AppException catch (error) {
      return Failure(error);
    } catch (error, stackTrace) {
      return Failure(
        AppExceptionFactory.unexpected(
          source:
              'FriendRepositoryImpl - getPendingRequests',
          error: error,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  @override
  Future<Result<void>> respondToRequest({
    required int friendshipId,
    required bool accept,
  }) async {
    try {
      await _remoteDataSource.respondToRequest(
        friendshipId: friendshipId,
        accept: accept,
      );
      return const Success(null);
    } on AppException catch (error) {
      return Failure(error);
    } catch (error, stackTrace) {
      return Failure(
        AppExceptionFactory.unexpected(
          source:
              'FriendRepositoryImpl - respondToRequest',
          error: error,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  @override
  Future<Result<List<UserSummaryEntity>>>
  getMyFriends() async {
    try {
      final dtos = await _remoteDataSource
          .getMyFriends();
      return Success(
        dtos
            .map((dto) => dto.toEntity())
            .toList(),
      );
    } on AppException catch (error) {
      return Failure(error);
    } catch (error, stackTrace) {
      return Failure(
        AppExceptionFactory.unexpected(
          source:
              'FriendRepositoryImpl - getMyFriends',
          error: error,
          stackTrace: stackTrace,
        ),
      );
    }
  }
}
