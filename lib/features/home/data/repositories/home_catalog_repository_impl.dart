import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../../../product/domain/entities/product.dart';
import '../../domain/entities/home_catalog.dart';
import '../../domain/repositories/home_catalog_repository.dart';
import '../datasources/home_catalog_local_data_source.dart';

final class HomeCatalogRepositoryImpl implements HomeCatalogRepository {
  HomeCatalogRepositoryImpl(this._local);

  final HomeCatalogLocalDataSource _local;

  @override
  Stream<Either<Failure, List<HomeBanner>>> watchBanners() =>
      _local.watchBanners().map(
        (result) => result.map(
          (rows) => List.unmodifiable(rows.map((row) => row.toEntity())),
        ),
      );

  @override
  Stream<Either<Failure, List<Product>>> watchSection(HomeSection section) =>
      _local
          .watchSection(section)
          .map(
            (result) => result.map(
              (rows) => List.unmodifiable(rows.map((row) => row.toEntity())),
            ),
          );

  @override
  Stream<Either<Failure, List<Shop>>> watchShops() => _local.watchShops().map(
    (result) => result.map(
      (rows) => List.unmodifiable(rows.map((row) => row.toEntity())),
    ),
  );
}
