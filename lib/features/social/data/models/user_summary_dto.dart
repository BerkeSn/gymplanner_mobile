// models/user_summary_dto.dart

import 'package:gymplanner_mobile/features/social/domain/entites/user_summary_entity.dart';

class UserSummaryDto {
  final int id;
  final String username;
  final String? name;
  final String? surname;

  UserSummaryDto({
    required this.id,
    required this.username,
    this.name,
    this.surname,
  });

  factory UserSummaryDto.fromJson(
    Map<String, dynamic> json,
  ) {
    try {
      return UserSummaryDto(
        id: json['id'] as int,
        username: json['username'] as String,
        name: json['name'] as String?,
        surname: json['surname'] as String?,
      );
    } catch (error, stackTrace) {
      throw Exception(
        '[UserSummaryDto - fromJson]: ${error.toString()}\n$stackTrace',
      );
    }
  }

  UserSummaryEntity toEntity() =>
      UserSummaryEntity(
        id: id,
        username: username,
        name: name,
        surname: surname,
      );
}
