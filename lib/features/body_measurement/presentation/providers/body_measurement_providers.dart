// presentation/providers/body_measurement_providers.dart

import 'package:gymplanner_mobile/features/body_measurement/data/datasource/body_measurement_remote_datasource.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../auth/presentation/providers/auth_providers.dart'
    show dioProvider;
import '../../data/repositories/body_measurement_repository_impl.dart';
import '../../domain/repositories/body_measurement_repository.dart';

part 'body_measurement_providers.g.dart';

@riverpod
BodyMeasurementRemoteDataSource
bodyMeasurementRemoteDataSource(
  BodyMeasurementRemoteDataSourceRef ref,
) {
  return BodyMeasurementRemoteDataSource(
    ref.watch(dioProvider),
  );
}

@riverpod
BodyMeasurementRepository
bodyMeasurementRepository(
  BodyMeasurementRepositoryRef ref,
) {
  return BodyMeasurementRepositoryImpl(
    ref.watch(
      bodyMeasurementRemoteDataSourceProvider,
    ),
  );
}
