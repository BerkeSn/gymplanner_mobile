// entities/exercise_entity.dart

class ExerciseEntity {
  final int id;
  final String name;
  final String? description;
  final String? imageUrl;
  final String
  difficulty; // 'Beginner' | 'Intermediate' | 'Advanced'
  final String muscleGroupName;
  final String equipmentName;

  const ExerciseEntity({
    required this.id,
    required this.name,
    this.description,
    this.imageUrl,
    required this.difficulty,
    required this.muscleGroupName,
    required this.equipmentName,
  });
}
