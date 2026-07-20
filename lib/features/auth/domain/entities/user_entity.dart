// entities/user_entity.dart

/// Backend User modelindeki gender enum'u ile birebir eşleşir.
enum Gender { male, female, other }

extension GenderX on Gender {
  String get apiValue =>
      name; // 'male' | 'female' | 'other'

  static Gender fromApi(String value) {
    return Gender.values.firstWhere(
      (g) => g.apiValue == value,
      orElse: () => Gender.other,
    );
  }
}

class UserEntity {
  final int id;
  final String username;
  final String email;
  final String name;
  final String surname;
  final String? phone;
  final DateTime? birthdate;
  final Gender gender;

  const UserEntity({
    required this.id,
    required this.username,
    required this.email,
    required this.name,
    required this.surname,
    this.phone,
    this.birthdate,
    required this.gender,
  });
}
