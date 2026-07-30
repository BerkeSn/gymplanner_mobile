// models/conversation_participant_dto.dart

import 'package:gymplanner_mobile/features/messaging/domain/entites/conversation_participant_entity.dart';

class ConversationParticipantDto {
  final int id;
  final String username;
  final String? name;
  final String? surname;

  ConversationParticipantDto({
    required this.id,
    required this.username,
    this.name,
    this.surname,
  });

  factory ConversationParticipantDto.fromJson(
    Map<String, dynamic> json,
  ) {
    try {
      return ConversationParticipantDto(
        id: json['id'] as int,
        username: json['username'] as String,
        name: json['name'] as String?,
        surname: json['surname'] as String?,
      );
    } catch (error, stackTrace) {
      throw Exception(
        '[ConversationParticipantDto - fromJson]: ${error.toString()}\n$stackTrace',
      );
    }
  }

  ConversationParticipantEntity toEntity() =>
      ConversationParticipantEntity(
        id: id,
        username: username,
        name: name,
        surname: surname,
      );
}
