// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'storage_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(appDatabase)
final appDatabaseProvider = AppDatabaseProvider._();

final class AppDatabaseProvider
    extends $FunctionalProvider<AppDatabase, AppDatabase, AppDatabase>
    with $Provider<AppDatabase> {
  AppDatabaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appDatabaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appDatabaseHash();

  @$internal
  @override
  $ProviderElement<AppDatabase> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AppDatabase create(Ref ref) {
    return appDatabase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppDatabase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppDatabase>(value),
    );
  }
}

String _$appDatabaseHash() => r'd914b4598838f15faf8faa4d2ab039e12227a392';

@ProviderFor(catalogSeeder)
final catalogSeederProvider = CatalogSeederProvider._();

final class CatalogSeederProvider
    extends $FunctionalProvider<CatalogSeeder, CatalogSeeder, CatalogSeeder>
    with $Provider<CatalogSeeder> {
  CatalogSeederProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'catalogSeederProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$catalogSeederHash();

  @$internal
  @override
  $ProviderElement<CatalogSeeder> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  CatalogSeeder create(Ref ref) {
    return catalogSeeder(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CatalogSeeder value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CatalogSeeder>(value),
    );
  }
}

String _$catalogSeederHash() => r'2af4b6161a52799eca2cd176bfe2afd3f91ef171';

@ProviderFor(hiveSettings)
final hiveSettingsProvider = HiveSettingsProvider._();

final class HiveSettingsProvider
    extends $FunctionalProvider<HiveSettings, HiveSettings, HiveSettings>
    with $Provider<HiveSettings> {
  HiveSettingsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'hiveSettingsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$hiveSettingsHash();

  @$internal
  @override
  $ProviderElement<HiveSettings> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  HiveSettings create(Ref ref) {
    return hiveSettings(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(HiveSettings value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<HiveSettings>(value),
    );
  }
}

String _$hiveSettingsHash() => r'2c87db2c6175eecb222df457c269d5ae69994789';
