// presentation/providers/nutrition_providers.dart

import 'package:gymplanner_mobile/features/nutrition/data/datasource/nutrition_remote_datasource.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../auth/presentation/providers/auth_providers.dart'
    show dioProvider;
import '../../data/repositories/nutrition_repository_impl.dart';
import '../../domain/repositories/nutrition_repository.dart';

part 'nutrition_providers.g.dart';

@riverpod
NutritionRemoteDataSource
nutritionRemoteDataSource(
  NutritionRemoteDataSourceRef ref,
) {
  return NutritionRemoteDataSource(
    ref.watch(dioProvider),
  );
}

@riverpod
NutritionRepository nutritionRepository(
  NutritionRepositoryRef ref,
) {
  return NutritionRepositoryImpl(
    ref.watch(nutritionRemoteDataSourceProvider),
  );
}
