import '../../domain/entities/user_entity.dart';

class UserDto {
  final int id;
  final String username;
  final String email;
  final String name;
  final String surname;
  final String? phone;
  final String? birthdate;
  final String gender;
  final String? locationPreference; // ⬅️ YENİ

  UserDto({
    required this.id,
    required this.username,
    required this.email,
    required this.name,
    required this.surname,
    this.phone,
    this.birthdate,
    required this.gender,
    this.locationPreference,
  });

  factory UserDto.fromJson(
    Map<String, dynamic> json,
  ) {
    try {
      return UserDto(
        id: json['id'] as int,
        username: json['username'] as String,
        email: json['email'] as String,
        name: json['name'] as String,
        surname: json['surname'] as String,
        phone: json['phone'] as String?,
        birthdate: json['birthdate'] as String?,
        gender:
            json['gender'] as String? ?? 'other',
        locationPreference:
            json['locationPreference']
                as String?, // ⬅️ YENİ
      );
    } catch (error, stackTrace) {
      throw Exception(
        '[UserDto - fromJson]: Kullanıcı verisi parse edilemedi: $error\n$stackTrace',
      );
    }
  }

  UserEntity toEntity() {
    return UserEntity(
      id: id,
      username: username,
      email: email,
      name: name,
      surname: surname,
      phone: phone,
      birthdate: birthdate != null
          ? DateTime.tryParse(birthdate!)
          : null,
      gender: GenderX.fromApi(gender),
      locationPreference:
          LocationPreferenceX.fromApi(
            locationPreference ?? 'Gym',
          ), // ⬅️ YENİ
    );
  }
}
