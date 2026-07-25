// entities/meal_entry_entity.dart

import 'meal_type.dart';

class MealEntryEntity {
  final int id;
  final DateTime date;
  final MealType mealType;
  final String name;
  final double? servingWeight;
  final int calories;
  final double protein;
  final double carbs;
  final double fats;

  const MealEntryEntity({
    required this.id,
    required this.date,
    required this.mealType,
    required this.name,
    this.servingWeight,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fats,
  });
}
