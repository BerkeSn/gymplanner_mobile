// entities/daily_nutrition_summary.dart

import 'meal_entry_entity.dart';

class DailyNutritionSummary {
  final List<MealEntryEntity> meals;
  final int totalCalories;
  final double totalProtein;
  final double totalCarbs;
  final double totalFats;

  const DailyNutritionSummary({
    required this.meals,
    required this.totalCalories,
    required this.totalProtein,
    required this.totalCarbs,
    required this.totalFats,
  });
}
