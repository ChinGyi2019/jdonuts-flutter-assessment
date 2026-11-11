// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(homeCatalogLocalDataSource)
final homeCatalogLocalDataSourceProvider =
    HomeCatalogLocalDataSourceProvider._();

final class HomeCatalogLocalDataSourceProvider
    extends
        $FunctionalProvider<
          HomeCatalogLocalDataSource,
          HomeCatalogLocalDataSource,
          HomeCatalogLocalDataSource
        >
    with $Provider<HomeCatalogLocalDataSource> {
  HomeCatalogLocalDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'homeCatalogLocalDataSourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$homeCatalogLocalDataSourceHash();

  @$internal
  @override
  $ProviderElement<HomeCatalogLocalDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  HomeCatalogLocalDataSource create(Ref ref) {
    return homeCatalogLocalDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(HomeCatalogLocalDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<HomeCatalogLocalDataSource>(value),
    );
  }
}

String _$homeCatalogLocalDataSourceHash() =>
    r'50a281f1caf0d0d548e559365b47102effffbe81';

@ProviderFor(homeCatalogRepository)
final homeCatalogRepositoryProvider = HomeCatalogRepositoryProvider._();

final class HomeCatalogRepositoryProvider
    extends
        $FunctionalProvider<
          HomeCatalogRepository,
          HomeCatalogRepository,
          HomeCatalogRepository
        >
    with $Provider<HomeCatalogRepository> {
  HomeCatalogRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'homeCatalogRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$homeCatalogRepositoryHash();

  @$internal
  @override
  $ProviderElement<HomeCatalogRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  HomeCatalogRepository create(Ref ref) {
    return homeCatalogRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(HomeCatalogRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<HomeCatalogRepository>(value),
    );
  }
}

String _$homeCatalogRepositoryHash() =>
    r'7d659b5a5df5aebd5b1c001ef8998ae6a1c5c1dd';

@ProviderFor(homeBanners)
final homeBannersProvider = HomeBannersProvider._();

final class HomeBannersProvider
    extends
        $FunctionalProvider<
          AsyncValue<Either<Failure, List<HomeBanner>>>,
          Either<Failure, List<HomeBanner>>,
          Stream<Either<Failure, List<HomeBanner>>>
        >
    with
        $FutureModifier<Either<Failure, List<HomeBanner>>>,
        $StreamProvider<Either<Failure, List<HomeBanner>>> {
  HomeBannersProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'homeBannersProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$homeBannersHash();

  @$internal
  @override
  $StreamProviderElement<Either<Failure, List<HomeBanner>>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<Either<Failure, List<HomeBanner>>> create(Ref ref) {
    return homeBanners(ref);
  }
}

String _$homeBannersHash() => r'a38acf66f532af84d5b79fcaa97f985243f6ca8c';

@ProviderFor(homeSection)
final homeSectionProvider = HomeSectionFamily._();

final class HomeSectionProvider
    extends
        $FunctionalProvider<
          AsyncValue<Either<Failure, List<Product>>>,
          Either<Failure, List<Product>>,
          Stream<Either<Failure, List<Product>>>
        >
    with
        $FutureModifier<Either<Failure, List<Product>>>,
        $StreamProvider<Either<Failure, List<Product>>> {
  HomeSectionProvider._({
    required HomeSectionFamily super.from,
    required HomeSection super.argument,
  }) : super(
         retry: null,
         name: r'homeSectionProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$homeSectionHash();

  @override
  String toString() {
    return r'homeSectionProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<Either<Failure, List<Product>>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<Either<Failure, List<Product>>> create(Ref ref) {
    final argument = this.argument as HomeSection;
    return homeSection(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is HomeSectionProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$homeSectionHash() => r'b0effb70ae4a3f2aca09cbc01f316181862d847d';

final class HomeSectionFamily extends $Family
    with
        $FunctionalFamilyOverride<
          Stream<Either<Failure, List<Product>>>,
          HomeSection
        > {
  HomeSectionFamily._()
    : super(
        retry: null,
        name: r'homeSectionProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  HomeSectionProvider call(HomeSection section) =>
      HomeSectionProvider._(argument: section, from: this);

  @override
  String toString() => r'homeSectionProvider';
}

@ProviderFor(homeShops)
final homeShopsProvider = HomeShopsProvider._();

final class HomeShopsProvider
    extends
        $FunctionalProvider<
          AsyncValue<Either<Failure, List<Shop>>>,
          Either<Failure, List<Shop>>,
          Stream<Either<Failure, List<Shop>>>
        >
    with
        $FutureModifier<Either<Failure, List<Shop>>>,
        $StreamProvider<Either<Failure, List<Shop>>> {
  HomeShopsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'homeShopsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$homeShopsHash();

  @$internal
  @override
  $StreamProviderElement<Either<Failure, List<Shop>>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<Either<Failure, List<Shop>>> create(Ref ref) {
    return homeShops(ref);
  }
}

String _$homeShopsHash() => r'6eaf1809b0d5b99a96cf8fe989b4a479115e5f23';
