enum Gender { male, female, other }

extension GenderX on Gender {
  String get apiValue => name;

  static Gender fromApi(String value) {
    return Gender.values.firstWhere(
      (g) => g.apiValue == value,
      orElse: () => Gender.other,
    );
  }
}

enum LocationPreference { home, gym }

extension LocationPreferenceX
    on LocationPreference {
  String get apiValue {
    switch (this) {
      case LocationPreference.home:
        return 'Home';
      case LocationPreference.gym:
        return 'Gym';
    }
  }

  static LocationPreference fromApi(
    String value,
  ) {
    return value == 'Home'
        ? LocationPreference.home
        : LocationPreference.gym;
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
  final LocationPreference
  locationPreference; // ⬅️ YENİ

  const UserEntity({
    required this.id,
    required this.username,
    required this.email,
    required this.name,
    required this.surname,
    this.phone,
    this.birthdate,
    required this.gender,
    this.locationPreference =
        LocationPreference.gym, // ⬅️ YENİ
  });
}
