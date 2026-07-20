// presentation/controllers/signup_form_controller.dart

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

  const SignupFormData({
    this.fullName = '',
    this.username = '',
    this.email = '',
    this.phone = '',
    this.gender = Gender.male,
    this.password = '',
    this.birthdate,
  });

  SignupFormData copyWith({
    String? fullName,
    String? username,
    String? email,
    String? phone,
    Gender? gender,
    String? password,
    DateTime? birthdate,
  }) {
    return SignupFormData(
      fullName: fullName ?? this.fullName,
      username: username ?? this.username,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      gender: gender ?? this.gender,
      password: password ?? this.password,
      birthdate: birthdate ?? this.birthdate,
    );
  }
}

@Riverpod(
  keepAlive: true,
) // ⬅️ Bunun DOSYADA olduğunu satır satır doğrula
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

  void reset() => state = const SignupFormData();
}
