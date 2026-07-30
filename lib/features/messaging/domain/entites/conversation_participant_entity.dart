// entities/conversation_participant_entity.dart

class ConversationParticipantEntity {
  final int id;
  final String username;
  final String? name;
  final String? surname;

  const ConversationParticipantEntity({
    required this.id,
    required this.username,
    this.name,
    this.surname,
  });

  String get displayName {
    if (name != null && surname != null)
      return '$name $surname';
    return username;
  }
}
