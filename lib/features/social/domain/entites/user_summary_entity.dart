// entities/user_summary_entity.dart

/// Backend'in farklı endpoint'lerde farklı alan setleri döndürmesi
/// nedeniyle (searchUsers -> id/username/name/surname,
/// getMyFriends/getPendingRequests -> sadece id/username) name/surname
/// NULLABLE tutuluyor.
class UserSummaryEntity {
  final int id;
  final String username;
  final String? name;
  final String? surname;

  const UserSummaryEntity({
    required this.id,
    required this.username,
    this.name,
    this.surname,
  });

  /// UI'da gösterilecek görünen ad — name/surname yoksa username'e düşer.
  String get displayName {
    if (name != null && surname != null) return '$name $surname';
    return username;
  }
}