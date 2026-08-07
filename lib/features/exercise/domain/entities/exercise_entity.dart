// features/exercise/domain/entities/exercise_entity.dart

enum ExerciseLocation { home, gym, both }

extension ExerciseLocationX on ExerciseLocation {
  static ExerciseLocation fromApi(String value) {
    switch (value) {
      case 'Home':
        return ExerciseLocation.home;
      case 'Both':
        return ExerciseLocation.both;
      default:
        return ExerciseLocation.gym;
    }
  }

  /// Bir egzersiz seçili konum filtresine uygun mu? 'Both' her zaman uyar.
  bool matchesFilter(ExerciseLocation? filter) {
    if (filter == null) return true;
    return this == filter || this == ExerciseLocation.both;
  }
}

class ExerciseEntity {
  final int id;
  final String name;
  final String? description;
  final String? imageUrl;
  final String difficulty;
  final String muscleGroupName;
  final String equipmentName;
  final ExerciseLocation availableAt;   // ⬅️ YENİ

  const ExerciseEntity({
    required this.id,
    required this.name,
    this.description,
    this.imageUrl,
    required this.difficulty,
    required this.muscleGroupName,
    required this.equipmentName,
    this.availableAt = ExerciseLocation.gym,   // ⬅️ YENİ
  });
}