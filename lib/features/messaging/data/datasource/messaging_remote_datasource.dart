// datasources/messaging_remote_datasource.dart

import 'package:dio/dio.dart';

import '../../../../core/error/app_exception.dart';
import '../models/conversation_dto.dart';
import '../models/message_dto.dart';

class MessagingRemoteDataSource {
  final Dio _dio;
  const MessagingRemoteDataSource(this._dio);

  Future<int> startConversation(
    int friendId,
  ) async {
    try {
      final response = await _dio.post(
        '/message/startConversation/$friendId',
      );
      final data =
          response.data as Map<String, dynamic>;
      return data['conversationId'] as int;
    } on DioException catch (error, stackTrace) {
      throw AppExceptionFactory.network(
        source:
            'MessagingRemoteDataSource - startConversation',
        message:
            _extractMessage(error) ??
            'Sohbet başlatılamadı.',
        originalError: error,
        stackTrace: stackTrace,
      );
    } catch (error, stackTrace) {
      throw AppExceptionFactory.unexpected(
        source:
            'MessagingRemoteDataSource - startConversation',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  Future<List<ConversationDto>>
  getConversations() async {
    try {
      final response = await _dio.get(
        '/message/getConversations',
      );
      final data =
          response.data as Map<String, dynamic>;
      final list =
          data['conversations'] as List<dynamic>;
      return list
          .map(
            (json) => ConversationDto.fromJson(
              json as Map<String, dynamic>,
            ),
          )
          .toList();
    } on DioException catch (error, stackTrace) {
      throw AppExceptionFactory.network(
        source:
            'MessagingRemoteDataSource - getConversations',
        message:
            _extractMessage(error) ??
            'Sohbetler alınamadı.',
        originalError: error,
        stackTrace: stackTrace,
      );
    } catch (error, stackTrace) {
      throw AppExceptionFactory.unexpected(
        source:
            'MessagingRemoteDataSource - getConversations',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  Future<List<MessageDto>> getMessages(
    int conversationId,
  ) async {
    try {
      final response = await _dio.get(
        '/message/getMessages/$conversationId',
      );
      final data =
          response.data as Map<String, dynamic>;
      final list =
          data['messages'] as List<dynamic>;
      return list
          .map(
            (json) => MessageDto.fromJson(
              json as Map<String, dynamic>,
            ),
          )
          .toList();
    } on DioException catch (error, stackTrace) {
      throw AppExceptionFactory.network(
        source:
            'MessagingRemoteDataSource - getMessages',
        message:
            _extractMessage(error) ??
            'Mesajlar alınamadı.',
        originalError: error,
        stackTrace: stackTrace,
      );
    } catch (error, stackTrace) {
      throw AppExceptionFactory.unexpected(
        source:
            'MessagingRemoteDataSource - getMessages',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  Future<MessageDto> sendMessage({
    required int conversationId,
    required String content,
  }) async {
    try {
      final response = await _dio.post(
        '/message/sendMessage/$conversationId',
        data: {
          'type': 'text',
          'content': content,
        },
      );
      final data =
          response.data as Map<String, dynamic>;
      return MessageDto.fromJson(
        data['message'] as Map<String, dynamic>,
      );
    } on DioException catch (error, stackTrace) {
      throw AppExceptionFactory.network(
        source:
            'MessagingRemoteDataSource - sendMessage',
        message:
            _extractMessage(error) ??
            'Mesaj gönderilemedi.',
        originalError: error,
        stackTrace: stackTrace,
      );
    } catch (error, stackTrace) {
      throw AppExceptionFactory.unexpected(
        source:
            'MessagingRemoteDataSource - sendMessage',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> markAsRead(
    int conversationId,
  ) async {
    try {
      await _dio.post(
        '/message/markAsRead/$conversationId',
      );
    } on DioException catch (error, stackTrace) {
      throw AppExceptionFactory.network(
        source:
            'MessagingRemoteDataSource - markAsRead',
        message:
            _extractMessage(error) ??
            'Okundu bilgisi güncellenemedi.',
        originalError: error,
        stackTrace: stackTrace,
      );
    } catch (error, stackTrace) {
      throw AppExceptionFactory.unexpected(
        source:
            'MessagingRemoteDataSource - markAsRead',
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
