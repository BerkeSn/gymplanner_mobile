// features/auth/domain/entities/user_entity.dart

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

// ⬇️ YENİ — User.goal ile birebir eşleşir
enum UserGoal {
  loseWeight,
  gainMuscle,
  maintain,
  improveEndurance,
}

extension UserGoalX on UserGoal {
  String get apiValue {
    switch (this) {
      case UserGoal.loseWeight:
        return 'Lose Weight';
      case UserGoal.gainMuscle:
        return 'Gain Muscle';
      case UserGoal.maintain:
        return 'Maintain';
      case UserGoal.improveEndurance:
        return 'Improve Endurance';
    }
  }

  static UserGoal fromApi(String value) {
    switch (value) {
      case 'Lose Weight':
        return UserGoal.loseWeight;
      case 'Gain Muscle':
        return UserGoal.gainMuscle;
      case 'Improve Endurance':
        return UserGoal.improveEndurance;
      default:
        return UserGoal.maintain;
    }
  }
}

// ⬇️ YENİ — User.activityLevel ile birebir eşleşir (backend zaten lowercase string kullanıyor)
enum ActivityLevel {
  sedentary,
  light,
  moderate,
  active,
}

extension ActivityLevelX on ActivityLevel {
  String get apiValue => name;
  static ActivityLevel fromApi(String value) {
    return ActivityLevel.values.firstWhere(
      (a) => a.apiValue == value,
      orElse: () => ActivityLevel.moderate,
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
  final LocationPreference locationPreference;
  final UserGoal goal; // ⬅️ YENİ
  final ActivityLevel activityLevel; // ⬅️ YENİ

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
        LocationPreference.gym,
    this.goal = UserGoal.maintain, // ⬅️ YENİ
    this.activityLevel =
        ActivityLevel.moderate, // ⬅️ YENİ
  });
}
