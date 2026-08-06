// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meals_for_date_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$mealsForDateHash() => r'e3561e17bacbe21997af80516d29ea49de89d86c';

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

/// family: Dashboard'da seçilen HERHANGİ bir gün için öğün özetini getirir.
/// NutritionController'dan bağımsız — o her zaman "bugün" ile sınırlı,
/// bu ise takvimde gezinmeyi destekliyor.
///
/// Copied from [mealsForDate].
@ProviderFor(mealsForDate)
const mealsForDateProvider = MealsForDateFamily();

/// family: Dashboard'da seçilen HERHANGİ bir gün için öğün özetini getirir.
/// NutritionController'dan bağımsız — o her zaman "bugün" ile sınırlı,
/// bu ise takvimde gezinmeyi destekliyor.
///
/// Copied from [mealsForDate].
class MealsForDateFamily extends Family<AsyncValue<DailyNutritionSummary>> {
  /// family: Dashboard'da seçilen HERHANGİ bir gün için öğün özetini getirir.
  /// NutritionController'dan bağımsız — o her zaman "bugün" ile sınırlı,
  /// bu ise takvimde gezinmeyi destekliyor.
  ///
  /// Copied from [mealsForDate].
  const MealsForDateFamily();

  /// family: Dashboard'da seçilen HERHANGİ bir gün için öğün özetini getirir.
  /// NutritionController'dan bağımsız — o her zaman "bugün" ile sınırlı,
  /// bu ise takvimde gezinmeyi destekliyor.
  ///
  /// Copied from [mealsForDate].
  MealsForDateProvider call(DateTime date) {
    return MealsForDateProvider(date);
  }

  @override
  MealsForDateProvider getProviderOverride(
    covariant MealsForDateProvider provider,
  ) {
    return call(provider.date);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'mealsForDateProvider';
}

/// family: Dashboard'da seçilen HERHANGİ bir gün için öğün özetini getirir.
/// NutritionController'dan bağımsız — o her zaman "bugün" ile sınırlı,
/// bu ise takvimde gezinmeyi destekliyor.
///
/// Copied from [mealsForDate].
class MealsForDateProvider
    extends AutoDisposeFutureProvider<DailyNutritionSummary> {
  /// family: Dashboard'da seçilen HERHANGİ bir gün için öğün özetini getirir.
  /// NutritionController'dan bağımsız — o her zaman "bugün" ile sınırlı,
  /// bu ise takvimde gezinmeyi destekliyor.
  ///
  /// Copied from [mealsForDate].
  MealsForDateProvider(DateTime date)
    : this._internal(
        (ref) => mealsForDate(ref as MealsForDateRef, date),
        from: mealsForDateProvider,
        name: r'mealsForDateProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$mealsForDateHash,
        dependencies: MealsForDateFamily._dependencies,
        allTransitiveDependencies:
            MealsForDateFamily._allTransitiveDependencies,
        date: date,
      );

  MealsForDateProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.date,
  }) : super.internal();

  final DateTime date;

  @override
  Override overrideWith(
    FutureOr<DailyNutritionSummary> Function(MealsForDateRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: MealsForDateProvider._internal(
        (ref) => create(ref as MealsForDateRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        date: date,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<DailyNutritionSummary> createElement() {
    return _MealsForDateProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MealsForDateProvider && other.date == date;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, date.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin MealsForDateRef on AutoDisposeFutureProviderRef<DailyNutritionSummary> {
  /// The parameter `date` of this provider.
  DateTime get date;
}

class _MealsForDateProviderElement
    extends AutoDisposeFutureProviderElement<DailyNutritionSummary>
    with MealsForDateRef {
  _MealsForDateProviderElement(super.provider);

  @override
  DateTime get date => (origin as MealsForDateProvider).date;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
