// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'catalog_refresh_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(catalogRefresh)
final catalogRefreshProvider = CatalogRefreshProvider._();

final class CatalogRefreshProvider
    extends $FunctionalProvider<CatalogRefresh, CatalogRefresh, CatalogRefresh>
    with $Provider<CatalogRefresh> {
  CatalogRefreshProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'catalogRefreshProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$catalogRefreshHash();

  @$internal
  @override
  $ProviderElement<CatalogRefresh> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  CatalogRefresh create(Ref ref) {
    return catalogRefresh(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CatalogRefresh value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CatalogRefresh>(value),
    );
  }
}

String _$catalogRefreshHash() => r'c84f20321b0cc7cbae6f3510cb9cfcfc5058a5f4';
