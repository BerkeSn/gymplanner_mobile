import 'package:gymplanner_mobile/features/workout_log/domain/entites/streak_analytics_entity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/error/result.dart';
import '../../../../core/utils/app_logger.dart';
import '../providers/workout_log_providers.dart';

part 'streak_analytics_controller.g.dart';

@riverpod
class StreakAnalyticsController
    extends _$StreakAnalyticsController {
  @override
  Future<StreakAnalyticsEntity> build() async {
    try {
      final repository = ref.read(
        workoutLogRepositoryProvider,
      );
      final result = await repository
          .getStreakAnalytics();
      if (result
          is Failure<StreakAnalyticsEntity>) {
        throw result.exception;
      }
      return (result
              as Success<StreakAnalyticsEntity>)
          .data;
    } catch (error, stackTrace) {
      AppLogger.error(
        'StreakAnalyticsController - build',
        error,
        stackTrace,
      );
      rethrow;
    }
  }

  Future<void> refresh() async {
    state = await AsyncValue.guard(() => build());
  }
}
