// entities/conversation_entity.dart

import 'conversation_participant_entity.dart';
import 'message_entity.dart';

class ConversationEntity {
  final int id;
  final bool isGroup;
  final String? name;
  final List<ConversationParticipantEntity>
  participants;
  final MessageEntity? lastMessage;
  final bool isUnread;

  const ConversationEntity({
    required this.id,
    required this.isGroup,
    this.name,
    required this.participants,
    this.lastMessage,
    required this.isUnread,
  });

  /// İkili sohbette (grup değil) karşı tarafın adı — mevcut kullanıcının
  /// ID'si ile karşılaştırıp diğerini bulur.
  String displayName(int currentUserId) {
    if (isGroup && name != null) return name!;
    final other = participants
        .where((p) => p.id != currentUserId)
        .firstOrNull;
    return other?.displayName ?? 'Bilinmeyen';
  }
}
