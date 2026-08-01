// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'live_walk_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$liveWalkControllerHash() =>
    r'54ca07b53ad58dad001eab141208a11e7c929a78';

/// Tek bir aktif yürüyüş oturumunu yönetir: GPS ile mesafe/rota, pedometer
/// ile adım sayısı, Timer ile süre. autoDispose (varsayılan @riverpod) —
/// aktif yürüyüş ekranından çıkınca sensör dinleyicileri temizlenmeli.
///
/// Copied from [LiveWalkController].
@ProviderFor(LiveWalkController)
final liveWalkControllerProvider =
    AutoDisposeNotifierProvider<LiveWalkController, LiveWalkState>.internal(
      LiveWalkController.new,
      name: r'liveWalkControllerProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$liveWalkControllerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$LiveWalkController = AutoDisposeNotifier<LiveWalkState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
