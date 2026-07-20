// models/exercise_dto.dart

import '../../domain/entities/exercise_entity.dart';

class ExerciseDto {
  final int id;
  final String name;
  final String? description;
  final String? imageUrl;
  final String difficulty;
  final String muscleGroupName;
  final String equipmentName;

  ExerciseDto({
    required this.id,
    required this.name,
    this.description,
    this.imageUrl,
    required this.difficulty,
    required this.muscleGroupName,
    required this.equipmentName,
  });

  /// Backend `include` ile muscleGroup/equipment ilişkisini iç içe JSON
  /// olarak gönderiyor: { muscleGroup: { name }, equipment: { name } }
  factory ExerciseDto.fromJson(
    Map<String, dynamic> json,
  ) {
    try {
      final muscleGroup =
          json['muscleGroup']
              as Map<String, dynamic>?;
      final equipment =
          json['equipment']
              as Map<String, dynamic>?;
      return ExerciseDto(
        id: json['id'] as int,
        name: json['name'] as String,
        description:
            json['description'] as String?,
        imageUrl: json['imageUrl'] as String?,
        difficulty:
            json['difficulty'] as String? ??
            'Beginner',
        muscleGroupName:
            muscleGroup?['name'] as String? ??
            '—',
        equipmentName:
            equipment?['name'] as String? ?? '—',
      );
    } catch (error, stackTrace) {
      throw Exception(
        '[ExerciseDto - fromJson]: ${error.toString()}\n$stackTrace',
      );
    }
  }

  ExerciseEntity toEntity() => ExerciseEntity(
    id: id,
    name: name,
    description: description,
    imageUrl: imageUrl,
    difficulty: difficulty,
    muscleGroupName: muscleGroupName,
    equipmentName: equipmentName,
  );
}
