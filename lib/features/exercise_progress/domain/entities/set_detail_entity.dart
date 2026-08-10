// features/exercise_progress/domain/entities/set_detail_entity.dart (yeni dosya)

class SetDetailEntity {
  final int id;
  final int setNumber;
  final int reps;
  final double weight;
  const SetDetailEntity({
    required this.id,
    required this.setNumber,
    required this.reps,
    required this.weight,
  });
}
