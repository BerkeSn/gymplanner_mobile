// presentation/controllers/walk_history_controller.dart

import 'package:gymplanner_mobile/features/walk_tracking/domain/entites/walk_session_entity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/error/result.dart';
import '../../../../core/utils/app_logger.dart';
import '../providers/walk_providers.dart';

part 'walk_history_controller.g.dart';

@riverpod
class WalkHistoryController
    extends _$WalkHistoryController {
  @override
  FutureOr<List<WalkSessionEntity>>
  build() async {
    try {
      final repository = ref.read(
        walkRepositoryProvider,
      );
      final result = await repository
          .getWalkHistory();
      if (result
          is Failure<List<WalkSessionEntity>>) {
        throw result.exception;
      }
      return (result
              as Success<List<WalkSessionEntity>>)
          .data;
    } catch (error, stackTrace) {
      AppLogger.error(
        'WalkHistoryController - build',
        error,
        stackTrace,
      );
      rethrow;
    }
  }
}
