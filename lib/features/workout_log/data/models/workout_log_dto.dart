// models/workout_log_dto.dart
import 'package:gymplanner_mobile/features/workout_log/domain/entites/workout_log_entity.dart';

class WorkoutLogDto {
  final int id;
  final String date;
  final int workoutRoutineId;

  WorkoutLogDto({
    required this.id,
    required this.date,
    required this.workoutRoutineId,
  });

  factory WorkoutLogDto.fromJson(Map<String, dynamic> json) {
    try {
      return WorkoutLogDto(
        id: json['id'] as int,
        date: json['date'] as String,
        workoutRoutineId: json['workoutRoutineId'] as int,
      );
    } catch (error, stackTrace) {
      throw Exception(
          '[WorkoutLogDto - fromJson]: ${error.toString()}\n$stackTrace');
    }
  }

  WorkoutLogEntity toEntity() => WorkoutLogEntity(
        id: id,
        date: DateTime.tryParse(date) ?? DateTime.now(),
        workoutRoutineId: workoutRoutineId,
      );
}