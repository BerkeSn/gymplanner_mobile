import 'package:gymplanner_mobile/features/nutrition/domain/entites/daily_nutrition_summary.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/error/result.dart';
import '../../../../core/utils/app_logger.dart';
import '../providers/nutrition_providers.dart';

part 'meals_for_date_provider.g.dart';

/// family: Dashboard'da seçilen HERHANGİ bir gün için öğün özetini getirir.
/// NutritionController'dan bağımsız — o her zaman "bugün" ile sınırlı,
/// bu ise takvimde gezinmeyi destekliyor.
@riverpod
Future<DailyNutritionSummary> mealsForDate(
  MealsForDateRef ref,
  DateTime date,
) async {
  try {
    final repository = ref.read(
      nutritionRepositoryProvider,
    );
    final result = await repository
        .getMealsByDate(date);
    if (result
        is Failure<DailyNutritionSummary>) {
      throw result.exception;
    }
    return (result
            as Success<DailyNutritionSummary>)
        .data;
  } catch (error, stackTrace) {
    AppLogger.error(
      'mealsForDate - provider',
      error,
      stackTrace,
    );
    rethrow;
  }
}
