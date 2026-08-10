// features/workout_log/domain/entities/logged_set_entity.dart (yeni dosya)

class LoggedSetEntity {
  final int id;
  final int exerciseId;
  final String? exerciseName;
  final String? exerciseImageUrl;
  final int setNumber;
  final int reps;
  final double weight;

  const LoggedSetEntity({
    required this.id,
    required this.exerciseId,
    this.exerciseName,
    this.exerciseImageUrl,
    required this.setNumber,
    required this.reps,
    required this.weight,
  });
}