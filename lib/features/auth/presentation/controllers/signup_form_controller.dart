import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/user_entity.dart';

part 'signup_form_controller.g.dart';

class SignupFormData {
  final String fullName;
  final String username;
  final String email;
  final String phone;
  final Gender gender;
  final String password;
  final DateTime? birthdate;
  final LocationPreference
  locationPreference; // ⬅️ YENİ
  final UserGoal goal; // ⬅️ YENİ
  final ActivityLevel activityLevel; // ⬅️ YENİ

  const SignupFormData({
    this.fullName = '',
    this.username = '',
    this.email = '',
    this.phone = '',
    this.gender = Gender.male,
    this.password = '',
    this.birthdate,
    this.locationPreference =
        LocationPreference.gym,
    this.goal = UserGoal.maintain,
    this.activityLevel = ActivityLevel.moderate,
  });

  SignupFormData copyWith({
    String? fullName,
    String? username,
    String? email,
    String? phone,
    Gender? gender,
    String? password,
    DateTime? birthdate,
    LocationPreference? locationPreference,
    UserGoal? goal,
    ActivityLevel? activityLevel,
  }) {
    return SignupFormData(
      fullName: fullName ?? this.fullName,
      username: username ?? this.username,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      gender: gender ?? this.gender,
      password: password ?? this.password,
      birthdate: birthdate ?? this.birthdate,
      locationPreference:
          locationPreference ??
          this.locationPreference,
      goal: goal ?? this.goal,
      activityLevel:
          activityLevel ?? this.activityLevel,
    );
  }
}

@Riverpod(keepAlive: true)
class SignupFormController
    extends _$SignupFormController {
  @override
  SignupFormData build() =>
      const SignupFormData();

  void updateStep1({
    required String fullName,
    required String username,
    required String email,
    required String phone,
    required Gender gender,
    required String password,
    required DateTime birthdate,
  }) {
    try {
      state = state.copyWith(
        fullName: fullName,
        username: username,
        email: email,
        phone: phone,
        gender: gender,
        password: password,
        birthdate: birthdate,
      );
    } catch (error, stackTrace) {
      throw Exception(
        '[SignupFormController - updateStep1]: ${error.toString()}\n$stackTrace',
      );
    }
  }

  // ⬇️ YENİ: Step 2'deki ek tercihleri kaydeder.
  void updateStep2Preferences({
    required LocationPreference
    locationPreference,
    required UserGoal goal,
    required ActivityLevel activityLevel,
  }) {
    try {
      state = state.copyWith(
        locationPreference: locationPreference,
        goal: goal,
        activityLevel: activityLevel,
      );
    } catch (error, stackTrace) {
      throw Exception(
        '[SignupFormController - updateStep2Preferences]: ${error.toString()}\n$stackTrace',
      );
    }
  }

  void reset() => state = const SignupFormData();
}
