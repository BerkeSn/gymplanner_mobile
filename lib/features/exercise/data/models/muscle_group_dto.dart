// models/muscle_group_dto.dart

import '../../domain/entities/muscle_group_entity.dart';

class MuscleGroupDto {
  final int id;
  final String name;
  final String? description;
  final String? imageUrl;

  MuscleGroupDto({
    required this.id,
    required this.name,
    this.description,
    this.imageUrl,
  });

  factory MuscleGroupDto.fromJson(
    Map<String, dynamic> json,
  ) {
    try {
      return MuscleGroupDto(
        id: json['id'] as int,
        name: json['name'] as String,
        description:
            json['description'] as String?,
        imageUrl: json['imageUrl'] as String?,
      );
    } catch (error, stackTrace) {
      throw Exception(
        '[MuscleGroupDto - fromJson]: ${error.toString()}\n$stackTrace',
      );
    }
  }

  MuscleGroupEntity toEntity() =>
      MuscleGroupEntity(
        id: id,
        name: name,
        description: description,
        imageUrl: imageUrl,
      );
}
