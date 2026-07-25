// datasources/nutrition_remote_datasource.dart

import 'package:dio/dio.dart';

import '../../../../core/error/app_exception.dart';
import '../models/meal_entry_dto.dart';

class NutritionRemoteDataSource {
  final Dio _dio;
  const NutritionRemoteDataSource(this._dio);

  Future<Map<String, dynamic>> getTarget() async {
    try {
      final response = await _dio.get(
        '/calorie/getTarget',
      );
      final data =
          response.data as Map<String, dynamic>;
      return data['target']
          as Map<String, dynamic>;
    } on DioException catch (error, stackTrace) {
      throw AppExceptionFactory.network(
        source:
            'NutritionRemoteDataSource - getTarget',
        message:
            _extractMessage(error) ??
            'Kalori hedefi alınamadı.',
        originalError: error,
        stackTrace: stackTrace,
      );
    } catch (error, stackTrace) {
      throw AppExceptionFactory.unexpected(
        source:
            'NutritionRemoteDataSource - getTarget',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  Future<
    (List<MealEntryDto>, Map<String, dynamic>)
  >
  getMealsByDate(String date) async {
    try {
      final response = await _dio.get(
        '/meal/getMealsByDate',
        queryParameters: {'date': date},
      );
      final data =
          response.data as Map<String, dynamic>;
      final meals =
          (data['meals'] as List<dynamic>)
              .map(
                (json) => MealEntryDto.fromJson(
                  json as Map<String, dynamic>,
                ),
              )
              .toList();
      final summary =
          data['summary'] as Map<String, dynamic>;
      return (meals, summary);
    } on DioException catch (error, stackTrace) {
      throw AppExceptionFactory.network(
        source:
            'NutritionRemoteDataSource - getMealsByDate',
        message:
            _extractMessage(error) ??
            'Öğünler alınamadı.',
        originalError: error,
        stackTrace: stackTrace,
      );
    } catch (error, stackTrace) {
      throw AppExceptionFactory.unexpected(
        source:
            'NutritionRemoteDataSource - getMealsByDate',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  Future<List<Map<String, dynamic>>>
  getCalorieTrend(int days) async {
    try {
      final response = await _dio.get(
        '/meal/getCalorieTrend',
        queryParameters: {'days': days},
      );
      final data =
          response.data as Map<String, dynamic>;
      return (data['trend'] as List<dynamic>)
          .cast<Map<String, dynamic>>();
    } on DioException catch (error, stackTrace) {
      throw AppExceptionFactory.network(
        source:
            'NutritionRemoteDataSource - getCalorieTrend',
        message:
            _extractMessage(error) ??
            'Trend verisi alınamadı.',
        originalError: error,
        stackTrace: stackTrace,
      );
    } catch (error, stackTrace) {
      throw AppExceptionFactory.unexpected(
        source:
            'NutritionRemoteDataSource - getCalorieTrend',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> createMeal({
    String? date,
    required String mealType,
    required String name,
    double? servingWeight,
    required int calories,
    required double protein,
    required double carbs,
    required double fats,
  }) async {
    try {
      await _dio.post(
        '/meal/createMeal',
        data: {
          if (date != null) 'date': date,
          'mealType': mealType,
          'name': name,
          if (servingWeight != null)
            'servingWeight': servingWeight,
          'calories': calories,
          'protein': protein,
          'carbs': carbs,
          'fats': fats,
        },
      );
    } on DioException catch (error, stackTrace) {
      throw AppExceptionFactory.network(
        source:
            'NutritionRemoteDataSource - createMeal',
        message:
            _extractMessage(error) ??
            'Öğün kaydedilemedi.',
        originalError: error,
        stackTrace: stackTrace,
      );
    } catch (error, stackTrace) {
      throw AppExceptionFactory.unexpected(
        source:
            'NutritionRemoteDataSource - createMeal',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> deleteMeal(int id) async {
    try {
      await _dio.delete('/meal/deleteMeal/$id');
    } on DioException catch (error, stackTrace) {
      throw AppExceptionFactory.network(
        source:
            'NutritionRemoteDataSource - deleteMeal',
        message:
            _extractMessage(error) ??
            'Öğün silinemedi.',
        originalError: error,
        stackTrace: stackTrace,
      );
    } catch (error, stackTrace) {
      throw AppExceptionFactory.unexpected(
        source:
            'NutritionRemoteDataSource - deleteMeal',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  String? _extractMessage(DioException error) {
    final data = error.response?.data;
    if (data is Map<String, dynamic>) {
      return (data['message'] ?? data['error'])
          ?.toString();
    }
    return null;
  }
}
