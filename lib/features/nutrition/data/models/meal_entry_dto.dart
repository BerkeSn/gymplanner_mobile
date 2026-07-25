// models/meal_entry_dto.dart

import 'package:gymplanner_mobile/features/nutrition/domain/entites/meal_entry_entity.dart';
import 'package:gymplanner_mobile/features/nutrition/domain/entites/meal_type.dart';

class MealEntryDto {
  final int id;
  final String date;
  final String mealType;
  final String name;
  final num? servingWeight;
  final int calories;
  final num protein;
  final num carbs;
  final num fats;

  MealEntryDto({
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

  factory MealEntryDto.fromJson(
    Map<String, dynamic> json,
  ) {
    try {
      return MealEntryDto(
        id: json['id'] as int,
        date: json['date'] as String,
        mealType:
            json['mealType'] as String? ??
            'Snack',
        name: json['name'] as String,
        servingWeight:
            json['servingWeight'] as num?,
        calories: json['calories'] as int,
        protein: json['protein'] as num? ?? 0,
        carbs: json['carbs'] as num? ?? 0,
        fats: json['fats'] as num? ?? 0,
      );
    } catch (error, stackTrace) {
      throw Exception(
        '[MealEntryDto - fromJson]: ${error.toString()}\n$stackTrace',
      );
    }
  }

  MealEntryEntity toEntity() => MealEntryEntity(
    id: id,
    date:
        DateTime.tryParse(date) ?? DateTime.now(),
    mealType: MealTypeX.fromApi(mealType),
    name: name,
    servingWeight: servingWeight?.toDouble(),
    calories: calories,
    protein: protein.toDouble(),
    carbs: carbs.toDouble(),
    fats: fats.toDouble(),
  );
}
