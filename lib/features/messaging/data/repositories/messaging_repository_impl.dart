// repositories/messaging_repository_impl.dart

import 'package:gymplanner_mobile/features/messaging/data/datasource/messaging_remote_datasource.dart';
import 'package:gymplanner_mobile/features/messaging/domain/entites/conversation_entity.dart';
import 'package:gymplanner_mobile/features/messaging/domain/entites/message_entity.dart';

import '../../../../core/error/app_exception.dart';
import '../../../../core/error/result.dart';
import '../../domain/repositories/messaging_repository.dart';

class MessagingRepositoryImpl
    implements MessagingRepository {
  final MessagingRemoteDataSource
  _remoteDataSource;
  const MessagingRepositoryImpl(
    this._remoteDataSource,
  );

  @override
  Future<Result<int>> startConversation(
    int friendId,
  ) async {
    try {
      final id = await _remoteDataSource
          .startConversation(friendId);
      return Success(id);
    } on AppException catch (error) {
      return Failure(error);
    } catch (error, stackTrace) {
      return Failure(
        AppExceptionFactory.unexpected(
          source:
              'MessagingRepositoryImpl - startConversation',
          error: error,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  @override
  Future<Result<List<ConversationEntity>>>
  getConversations() async {
    try {
      final dtos = await _remoteDataSource
          .getConversations();
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
              'MessagingRepositoryImpl - getConversations',
          error: error,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  @override
  Future<Result<List<MessageEntity>>> getMessages(
    int conversationId,
  ) async {
    try {
      final dtos = await _remoteDataSource
          .getMessages(conversationId);
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
              'MessagingRepositoryImpl - getMessages',
          error: error,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  @override
  Future<Result<MessageEntity>> sendMessage({
    required int conversationId,
    required String content,
  }) async {
    try {
      final dto = await _remoteDataSource
          .sendMessage(
            conversationId: conversationId,
            content: content,
          );
      return Success(dto.toEntity());
    } on AppException catch (error) {
      return Failure(error);
    } catch (error, stackTrace) {
      return Failure(
        AppExceptionFactory.unexpected(
          source:
              'MessagingRepositoryImpl - sendMessage',
          error: error,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  @override
  Future<Result<void>> markAsRead(
    int conversationId,
  ) async {
    try {
      await _remoteDataSource.markAsRead(
        conversationId,
      );
      return const Success(null);
    } on AppException catch (error) {
      return Failure(error);
    } catch (error, stackTrace) {
      return Failure(
        AppExceptionFactory.unexpected(
          source:
              'MessagingRepositoryImpl - markAsRead',
          error: error,
          stackTrace: stackTrace,
        ),
      );
    }
  }
}
