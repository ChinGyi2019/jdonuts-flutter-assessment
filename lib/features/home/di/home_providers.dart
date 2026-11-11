import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/error/failure.dart';
import '../../../core/storage/storage_providers.dart';
import '../../product/domain/entities/product.dart';
import '../data/datasources/home_catalog_local_data_source.dart';
import '../data/repositories/home_catalog_repository_impl.dart';
import '../domain/entities/home_catalog.dart';
import '../domain/repositories/home_catalog_repository.dart';

part 'home_providers.g.dart';

@riverpod
HomeCatalogLocalDataSource homeCatalogLocalDataSource(Ref ref) =>
    HomeCatalogLocalDataSource(
      ref.watch(appDatabaseProvider),
      ref.watch(catalogSeederProvider),
    );

@riverpod
HomeCatalogRepository homeCatalogRepository(Ref ref) =>
    HomeCatalogRepositoryImpl(ref.watch(homeCatalogLocalDataSourceProvider));

@riverpod
Stream<Either<Failure, List<HomeBanner>>> homeBanners(Ref ref) =>
    ref.watch(homeCatalogRepositoryProvider).watchBanners();

@riverpod
Stream<Either<Failure, List<Product>>> homeSection(
  Ref ref,
  HomeSection section,
) => ref.watch(homeCatalogRepositoryProvider).watchSection(section);

@riverpod
Stream<Either<Failure, List<Shop>>> homeShops(Ref ref) =>
    ref.watch(homeCatalogRepositoryProvider).watchShops();
