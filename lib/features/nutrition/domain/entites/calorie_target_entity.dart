// entities/calorie_target_entity.dart

class CalorieTargetEntity {
  final int bmr;
  final int tdee;
  final String goal;
  final int targetCalories;

  const CalorieTargetEntity({
    required this.bmr,
    required this.tdee,
    required this.goal,
    required this.targetCalories,
  });
}
