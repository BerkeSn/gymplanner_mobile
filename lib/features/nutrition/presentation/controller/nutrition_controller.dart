// presentation/controllers/nutrition_controller.dart

import 'package:gymplanner_mobile/features/nutrition/domain/entites/calorie_target_entity.dart';
import 'package:gymplanner_mobile/features/nutrition/domain/entites/calorie_trend_point.dart';
import 'package:gymplanner_mobile/features/nutrition/domain/entites/daily_nutrition_summary.dart';
import 'package:gymplanner_mobile/features/nutrition/domain/entites/meal_type.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/error/result.dart';
import '../../../../core/utils/app_logger.dart';
import '../providers/nutrition_providers.dart';

part 'nutrition_controller.g.dart';

class NutritionState {
  final CalorieTargetEntity? target;
  final DailyNutritionSummary summary;
  final List<CalorieTrendPoint> trend;

  const NutritionState({
    required this.target,
    required this.summary,
    required this.trend,
  });
}

@Riverpod(keepAlive: true)
class NutritionController
    extends _$NutritionController {
  @override
  FutureOr<NutritionState> build() async {
    return _fetchAll();
  }

  Future<NutritionState> _fetchAll() async {
    try {
      final repository = ref.read(
        nutritionRepositoryProvider,
      );
      final today = DateTime.now();

      final targetResult = await repository
          .getTarget();
      final summaryResult = await repository
          .getMealsByDate(today);
      final trendResult = await repository
          .getCalorieTrend(days: 30);

      if (summaryResult
          is Failure<DailyNutritionSummary>) {
        throw summaryResult.exception;
      }

      // Hedef, henüz ölçüm/doğum tarihi girilmemişse backend'de 400
      // dönebilir (bkz. calorieController.getTarget) — bu KRİTİK DEĞİL,
      // ekranı çökertmek yerine null bırakıp UI'da "hedef henüz yok"
      // durumunu gösteriyoruz.
      final target =
          targetResult
              is Success<CalorieTargetEntity>
          ? targetResult.data
          : null;
      final trend =
          trendResult
              is Success<List<CalorieTrendPoint>>
          ? trendResult.data
          : <CalorieTrendPoint>[];

      return NutritionState(
        target: target,
        summary:
            (summaryResult
                    as Success<
                      DailyNutritionSummary
                    >)
                .data,
        trend: trend,
      );
    } catch (error, stackTrace) {
      AppLogger.error(
        'NutritionController - _fetchAll',
        error,
        stackTrace,
      );
      rethrow;
    }
  }

  Future<void> refresh() async {
    state = const AsyncLoading<NutritionState>()
        .copyWithPrevious(state);
    state = await AsyncValue.guard(_fetchAll);
  }

  Future<bool> addMeal({
    required MealType mealType,
    required String name,
    double? servingWeight,
    required int calories,
    double protein = 0,
    double carbs = 0,
    double fats = 0,
  }) async {
    try {
      final repository = ref.read(
        nutritionRepositoryProvider,
      );
      final result = await repository.createMeal(
        mealType: mealType,
        name: name,
        servingWeight: servingWeight,
        calories: calories,
        protein: protein,
        carbs: carbs,
        fats: fats,
      );
      if (result is Failure<void>) {
        throw result.exception;
      }
      await refresh();
      return true;
    } catch (error, stackTrace) {
      AppLogger.error(
        'NutritionController - addMeal',
        error,
        stackTrace,
      );
      return false;
    }
  }

  Future<void> deleteMeal(int id) async {
    try {
      final repository = ref.read(
        nutritionRepositoryProvider,
      );
      final result = await repository.deleteMeal(
        id,
      );
      if (result is Failure<void>) {
        throw result.exception;
      }
      await refresh();
    } catch (error, stackTrace) {
      AppLogger.error(
        'NutritionController - deleteMeal',
        error,
        stackTrace,
      );
    }
  }
}
