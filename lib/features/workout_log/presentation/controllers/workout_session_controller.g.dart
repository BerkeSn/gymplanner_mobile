// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout_session_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$workoutSessionControllerHash() =>
    r'6c7504fab7250abbc96ef17963b64fcd7796d612';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$WorkoutSessionController
    extends BuildlessAutoDisposeAsyncNotifier<WorkoutSessionState> {
  late final int routineId;

  FutureOr<WorkoutSessionState> build(int routineId);
}

/// family: her (routineId) için bağımsız bir oturum state'i.
/// autoDispose (varsayılan @riverpod) BİLİNÇLİ tercih — kullanıcı antrenman
/// ekranından çıkınca oturum state'i belleğinden silinmeli, bir sonraki
/// girişte YENİ bir startWorkoutLog çağrısı yapılmalı.
///
/// Copied from [WorkoutSessionController].
@ProviderFor(WorkoutSessionController)
const workoutSessionControllerProvider = WorkoutSessionControllerFamily();

/// family: her (routineId) için bağımsız bir oturum state'i.
/// autoDispose (varsayılan @riverpod) BİLİNÇLİ tercih — kullanıcı antrenman
/// ekranından çıkınca oturum state'i belleğinden silinmeli, bir sonraki
/// girişte YENİ bir startWorkoutLog çağrısı yapılmalı.
///
/// Copied from [WorkoutSessionController].
class WorkoutSessionControllerFamily
    extends Family<AsyncValue<WorkoutSessionState>> {
  /// family: her (routineId) için bağımsız bir oturum state'i.
  /// autoDispose (varsayılan @riverpod) BİLİNÇLİ tercih — kullanıcı antrenman
  /// ekranından çıkınca oturum state'i belleğinden silinmeli, bir sonraki
  /// girişte YENİ bir startWorkoutLog çağrısı yapılmalı.
  ///
  /// Copied from [WorkoutSessionController].
  const WorkoutSessionControllerFamily();

  /// family: her (routineId) için bağımsız bir oturum state'i.
  /// autoDispose (varsayılan @riverpod) BİLİNÇLİ tercih — kullanıcı antrenman
  /// ekranından çıkınca oturum state'i belleğinden silinmeli, bir sonraki
  /// girişte YENİ bir startWorkoutLog çağrısı yapılmalı.
  ///
  /// Copied from [WorkoutSessionController].
  WorkoutSessionControllerProvider call(int routineId) {
    return WorkoutSessionControllerProvider(routineId);
  }

  @override
  WorkoutSessionControllerProvider getProviderOverride(
    covariant WorkoutSessionControllerProvider provider,
  ) {
    return call(provider.routineId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'workoutSessionControllerProvider';
}

/// family: her (routineId) için bağımsız bir oturum state'i.
/// autoDispose (varsayılan @riverpod) BİLİNÇLİ tercih — kullanıcı antrenman
/// ekranından çıkınca oturum state'i belleğinden silinmeli, bir sonraki
/// girişte YENİ bir startWorkoutLog çağrısı yapılmalı.
///
/// Copied from [WorkoutSessionController].
class WorkoutSessionControllerProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<
          WorkoutSessionController,
          WorkoutSessionState
        > {
  /// family: her (routineId) için bağımsız bir oturum state'i.
  /// autoDispose (varsayılan @riverpod) BİLİNÇLİ tercih — kullanıcı antrenman
  /// ekranından çıkınca oturum state'i belleğinden silinmeli, bir sonraki
  /// girişte YENİ bir startWorkoutLog çağrısı yapılmalı.
  ///
  /// Copied from [WorkoutSessionController].
  WorkoutSessionControllerProvider(int routineId)
    : this._internal(
        () => WorkoutSessionController()..routineId = routineId,
        from: workoutSessionControllerProvider,
        name: r'workoutSessionControllerProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$workoutSessionControllerHash,
        dependencies: WorkoutSessionControllerFamily._dependencies,
        allTransitiveDependencies:
            WorkoutSessionControllerFamily._allTransitiveDependencies,
        routineId: routineId,
      );

  WorkoutSessionControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.routineId,
  }) : super.internal();

  final int routineId;

  @override
  FutureOr<WorkoutSessionState> runNotifierBuild(
    covariant WorkoutSessionController notifier,
  ) {
    return notifier.build(routineId);
  }

  @override
  Override overrideWith(WorkoutSessionController Function() create) {
    return ProviderOverride(
      origin: this,
      override: WorkoutSessionControllerProvider._internal(
        () => create()..routineId = routineId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        routineId: routineId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<
    WorkoutSessionController,
    WorkoutSessionState
  >
  createElement() {
    return _WorkoutSessionControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is WorkoutSessionControllerProvider &&
        other.routineId == routineId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, routineId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin WorkoutSessionControllerRef
    on AutoDisposeAsyncNotifierProviderRef<WorkoutSessionState> {
  /// The parameter `routineId` of this provider.
  int get routineId;
}

class _WorkoutSessionControllerProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          WorkoutSessionController,
          WorkoutSessionState
        >
    with WorkoutSessionControllerRef {
  _WorkoutSessionControllerProviderElement(super.provider);

  @override
  int get routineId => (origin as WorkoutSessionControllerProvider).routineId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
