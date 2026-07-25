// repositories/nutrition_repository.dart

import 'package:gymplanner_mobile/features/nutrition/domain/entites/calorie_target_entity.dart';
import 'package:gymplanner_mobile/features/nutrition/domain/entites/calorie_trend_point.dart';
import 'package:gymplanner_mobile/features/nutrition/domain/entites/daily_nutrition_summary.dart';
import 'package:gymplanner_mobile/features/nutrition/domain/entites/meal_type.dart';

import '../../../../core/error/result.dart';

abstract class NutritionRepository {
  Future<Result<CalorieTargetEntity>> getTarget();

  Future<Result<DailyNutritionSummary>>
  getMealsByDate(DateTime date);

  Future<Result<List<CalorieTrendPoint>>>
  getCalorieTrend({int days = 30});

  Future<Result<void>> createMeal({
    DateTime? date,
    required MealType mealType,
    required String name,
    double? servingWeight,
    required int calories,
    double protein = 0,
    double carbs = 0,
    double fats = 0,
  });

  Future<Result<void>> deleteMeal(int id);
}
