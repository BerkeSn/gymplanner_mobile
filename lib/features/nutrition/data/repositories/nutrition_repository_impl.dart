// repositories/nutrition_repository_impl.dart

import 'package:gymplanner_mobile/features/nutrition/data/datasource/nutrition_remote_datasource.dart';
import 'package:gymplanner_mobile/features/nutrition/domain/entites/calorie_target_entity.dart';
import 'package:gymplanner_mobile/features/nutrition/domain/entites/calorie_trend_point.dart';
import 'package:gymplanner_mobile/features/nutrition/domain/entites/daily_nutrition_summary.dart';
import 'package:gymplanner_mobile/features/nutrition/domain/entites/meal_type.dart';

import '../../../../core/error/app_exception.dart';
import '../../../../core/error/result.dart';
import '../../domain/repositories/nutrition_repository.dart';

class NutritionRepositoryImpl
    implements NutritionRepository {
  final NutritionRemoteDataSource
  _remoteDataSource;
  const NutritionRepositoryImpl(
    this._remoteDataSource,
  );

  String _formatDate(DateTime date) =>
      date.toIso8601String().split('T').first;

  @override
  Future<Result<CalorieTargetEntity>>
  getTarget() async {
    try {
      final json = await _remoteDataSource
          .getTarget();
      return Success(
        CalorieTargetEntity(
          bmr: json['bmr'] as int,
          tdee: json['tdee'] as int,
          goal: json['goal'] as String,
          targetCalories:
              json['targetCalories'] as int,
        ),
      );
    } on AppException catch (error) {
      return Failure(error);
    } catch (error, stackTrace) {
      return Failure(
        AppExceptionFactory.unexpected(
          source:
              'NutritionRepositoryImpl - getTarget',
          error: error,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  @override
  Future<Result<DailyNutritionSummary>>
  getMealsByDate(DateTime date) async {
    try {
      final (
        mealDtos,
        summaryJson,
      ) = await _remoteDataSource.getMealsByDate(
        _formatDate(date),
      );
      return Success(
        DailyNutritionSummary(
          meals: mealDtos
              .map((dto) => dto.toEntity())
              .toList(),
          totalCalories:
              (summaryJson['totalCalories']
                      as num)
                  .toInt(),
          totalProtein:
              (summaryJson['totalProtein'] as num)
                  .toDouble(),
          totalCarbs:
              (summaryJson['totalCarbs'] as num)
                  .toDouble(),
          totalFats:
              (summaryJson['totalFats'] as num)
                  .toDouble(),
        ),
      );
    } on AppException catch (error) {
      return Failure(error);
    } catch (error, stackTrace) {
      return Failure(
        AppExceptionFactory.unexpected(
          source:
              'NutritionRepositoryImpl - getMealsByDate',
          error: error,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  @override
  Future<Result<List<CalorieTrendPoint>>>
  getCalorieTrend({int days = 30}) async {
    try {
      final list = await _remoteDataSource
          .getCalorieTrend(days);
      final points =
          list
              .map(
                (json) => CalorieTrendPoint(
                  date:
                      DateTime.tryParse(
                        json['date'] as String,
                      ) ??
                      DateTime.now(),
                  totalCalories:
                      (json['totalCalories']
                              as num)
                          .toInt(),
                ),
              )
              .toList()
            ..sort(
              (a, b) => a.date.compareTo(b.date),
            );
      return Success(points);
    } on AppException catch (error) {
      return Failure(error);
    } catch (error, stackTrace) {
      return Failure(
        AppExceptionFactory.unexpected(
          source:
              'NutritionRepositoryImpl - getCalorieTrend',
          error: error,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  @override
  Future<Result<void>> createMeal({
    DateTime? date,
    required MealType mealType,
    required String name,
    double? servingWeight,
    required int calories,
    double protein = 0,
    double carbs = 0,
    double fats = 0,
  }) async {
    try {
      await _remoteDataSource.createMeal(
        date: date != null
            ? _formatDate(date)
            : null,
        mealType: mealType.apiValue,
        name: name,
        servingWeight: servingWeight,
        calories: calories,
        protein: protein,
        carbs: carbs,
        fats: fats,
      );
      return const Success(null);
    } on AppException catch (error) {
      return Failure(error);
    } catch (error, stackTrace) {
      return Failure(
        AppExceptionFactory.unexpected(
          source:
              'NutritionRepositoryImpl - createMeal',
          error: error,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  @override
  Future<Result<void>> deleteMeal(int id) async {
    try {
      await _remoteDataSource.deleteMeal(id);
      return const Success(null);
    } on AppException catch (error) {
      return Failure(error);
    } catch (error, stackTrace) {
      return Failure(
        AppExceptionFactory.unexpected(
          source:
              'NutritionRepositoryImpl - deleteMeal',
          error: error,
          stackTrace: stackTrace,
        ),
      );
    }
  }
}
