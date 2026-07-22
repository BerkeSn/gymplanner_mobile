// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exercise_progress_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$exerciseProgressHash() => r'94916a4d710efee20ad7fdf490c8de748a9dabcb';

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

/// family: her exerciseId için bağımsız state. Kasıtlı olarak autoDispose
/// (varsayılan @riverpod) — bu bir detay ekranı, ekrandan çıkınca veri
/// belleğinden silinmeli, geri dönüldüğünde taze veri çekilmeli.
///
/// Copied from [exerciseProgress].
@ProviderFor(exerciseProgress)
const exerciseProgressProvider = ExerciseProgressFamily();

/// family: her exerciseId için bağımsız state. Kasıtlı olarak autoDispose
/// (varsayılan @riverpod) — bu bir detay ekranı, ekrandan çıkınca veri
/// belleğinden silinmeli, geri dönüldüğünde taze veri çekilmeli.
///
/// Copied from [exerciseProgress].
class ExerciseProgressFamily
    extends Family<AsyncValue<List<ExerciseProgressEntry>>> {
  /// family: her exerciseId için bağımsız state. Kasıtlı olarak autoDispose
  /// (varsayılan @riverpod) — bu bir detay ekranı, ekrandan çıkınca veri
  /// belleğinden silinmeli, geri dönüldüğünde taze veri çekilmeli.
  ///
  /// Copied from [exerciseProgress].
  const ExerciseProgressFamily();

  /// family: her exerciseId için bağımsız state. Kasıtlı olarak autoDispose
  /// (varsayılan @riverpod) — bu bir detay ekranı, ekrandan çıkınca veri
  /// belleğinden silinmeli, geri dönüldüğünde taze veri çekilmeli.
  ///
  /// Copied from [exerciseProgress].
  ExerciseProgressProvider call(int exerciseId) {
    return ExerciseProgressProvider(exerciseId);
  }

  @override
  ExerciseProgressProvider getProviderOverride(
    covariant ExerciseProgressProvider provider,
  ) {
    return call(provider.exerciseId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'exerciseProgressProvider';
}

/// family: her exerciseId için bağımsız state. Kasıtlı olarak autoDispose
/// (varsayılan @riverpod) — bu bir detay ekranı, ekrandan çıkınca veri
/// belleğinden silinmeli, geri dönüldüğünde taze veri çekilmeli.
///
/// Copied from [exerciseProgress].
class ExerciseProgressProvider
    extends AutoDisposeFutureProvider<List<ExerciseProgressEntry>> {
  /// family: her exerciseId için bağımsız state. Kasıtlı olarak autoDispose
  /// (varsayılan @riverpod) — bu bir detay ekranı, ekrandan çıkınca veri
  /// belleğinden silinmeli, geri dönüldüğünde taze veri çekilmeli.
  ///
  /// Copied from [exerciseProgress].
  ExerciseProgressProvider(int exerciseId)
    : this._internal(
        (ref) => exerciseProgress(ref as ExerciseProgressRef, exerciseId),
        from: exerciseProgressProvider,
        name: r'exerciseProgressProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$exerciseProgressHash,
        dependencies: ExerciseProgressFamily._dependencies,
        allTransitiveDependencies:
            ExerciseProgressFamily._allTransitiveDependencies,
        exerciseId: exerciseId,
      );

  ExerciseProgressProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.exerciseId,
  }) : super.internal();

  final int exerciseId;

  @override
  Override overrideWith(
    FutureOr<List<ExerciseProgressEntry>> Function(ExerciseProgressRef provider)
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ExerciseProgressProvider._internal(
        (ref) => create(ref as ExerciseProgressRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        exerciseId: exerciseId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<ExerciseProgressEntry>>
  createElement() {
    return _ExerciseProgressProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ExerciseProgressProvider && other.exerciseId == exerciseId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, exerciseId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ExerciseProgressRef
    on AutoDisposeFutureProviderRef<List<ExerciseProgressEntry>> {
  /// The parameter `exerciseId` of this provider.
  int get exerciseId;
}

class _ExerciseProgressProviderElement
    extends AutoDisposeFutureProviderElement<List<ExerciseProgressEntry>>
    with ExerciseProgressRef {
  _ExerciseProgressProviderElement(super.provider);

  @override
  int get exerciseId => (origin as ExerciseProgressProvider).exerciseId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
