// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'public_profile_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$publicProfileControllerHash() =>
    r'f98bf314c121340f920fe59ee37c2067c0f2a0b5';

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

abstract class _$PublicProfileController
    extends BuildlessAutoDisposeAsyncNotifier<PublicProfileEntity> {
  late final int userId;

  FutureOr<PublicProfileEntity> build(int userId);
}

/// family: her userId için bağımsız state. autoDispose (varsayılan
/// @riverpod) — bu bir detay ekranı, çıkınca bellekten temizlenmeli.
///
/// Copied from [PublicProfileController].
@ProviderFor(PublicProfileController)
const publicProfileControllerProvider = PublicProfileControllerFamily();

/// family: her userId için bağımsız state. autoDispose (varsayılan
/// @riverpod) — bu bir detay ekranı, çıkınca bellekten temizlenmeli.
///
/// Copied from [PublicProfileController].
class PublicProfileControllerFamily
    extends Family<AsyncValue<PublicProfileEntity>> {
  /// family: her userId için bağımsız state. autoDispose (varsayılan
  /// @riverpod) — bu bir detay ekranı, çıkınca bellekten temizlenmeli.
  ///
  /// Copied from [PublicProfileController].
  const PublicProfileControllerFamily();

  /// family: her userId için bağımsız state. autoDispose (varsayılan
  /// @riverpod) — bu bir detay ekranı, çıkınca bellekten temizlenmeli.
  ///
  /// Copied from [PublicProfileController].
  PublicProfileControllerProvider call(int userId) {
    return PublicProfileControllerProvider(userId);
  }

  @override
  PublicProfileControllerProvider getProviderOverride(
    covariant PublicProfileControllerProvider provider,
  ) {
    return call(provider.userId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'publicProfileControllerProvider';
}

/// family: her userId için bağımsız state. autoDispose (varsayılan
/// @riverpod) — bu bir detay ekranı, çıkınca bellekten temizlenmeli.
///
/// Copied from [PublicProfileController].
class PublicProfileControllerProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<
          PublicProfileController,
          PublicProfileEntity
        > {
  /// family: her userId için bağımsız state. autoDispose (varsayılan
  /// @riverpod) — bu bir detay ekranı, çıkınca bellekten temizlenmeli.
  ///
  /// Copied from [PublicProfileController].
  PublicProfileControllerProvider(int userId)
    : this._internal(
        () => PublicProfileController()..userId = userId,
        from: publicProfileControllerProvider,
        name: r'publicProfileControllerProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$publicProfileControllerHash,
        dependencies: PublicProfileControllerFamily._dependencies,
        allTransitiveDependencies:
            PublicProfileControllerFamily._allTransitiveDependencies,
        userId: userId,
      );

  PublicProfileControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.userId,
  }) : super.internal();

  final int userId;

  @override
  FutureOr<PublicProfileEntity> runNotifierBuild(
    covariant PublicProfileController notifier,
  ) {
    return notifier.build(userId);
  }

  @override
  Override overrideWith(PublicProfileController Function() create) {
    return ProviderOverride(
      origin: this,
      override: PublicProfileControllerProvider._internal(
        () => create()..userId = userId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        userId: userId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<
    PublicProfileController,
    PublicProfileEntity
  >
  createElement() {
    return _PublicProfileControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PublicProfileControllerProvider && other.userId == userId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, userId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin PublicProfileControllerRef
    on AutoDisposeAsyncNotifierProviderRef<PublicProfileEntity> {
  /// The parameter `userId` of this provider.
  int get userId;
}

class _PublicProfileControllerProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          PublicProfileController,
          PublicProfileEntity
        >
    with PublicProfileControllerRef {
  _PublicProfileControllerProviderElement(super.provider);

  @override
  int get userId => (origin as PublicProfileControllerProvider).userId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
