import 'package:drift/drift.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/storage/app_database.dart';
import '../../../../core/storage/catalog_queries.dart';
import '../../../../core/storage/catalog_seeder.dart';
import '../../../product/data/models/product_model.dart';
import '../../domain/entities/home_catalog.dart';
import '../models/home_catalog_models.dart';

class HomeCatalogLocalDataSource {
  HomeCatalogLocalDataSource(this._db, this._seeder);

  final AppDatabase _db;
  final CatalogSeeder _seeder;

  Stream<Either<Failure, List<BannerModel>>> watchBanners() => watchLocal(
    _seeder,
    'Could not load banners',
    () => (_db.select(
      _db.banners,
    )..orderBy([(banner) => OrderingTerm.asc(banner.position)])).watch(),
  );

  Stream<Either<Failure, List<ProductModel>>> watchSection(
    HomeSection section,
  ) => watchLocal(_seeder, 'Could not load the product section', () {
    final products = _db.products;
    final sections = _db.sectionProducts;
    final query = _db.select(products).join([
      innerJoin(
        sections,
        sections.productId.equalsExp(products.id),
        useColumns: false,
      ),
    ]);
    query.where(sections.section.equalsValue(section));
    query.orderBy([OrderingTerm.asc(sections.position)]);
    return query.map((row) => row.readTable(products)).watch();
  });

  Stream<Either<Failure, List<ShopModel>>> watchShops() => watchLocal(
    _seeder,
    'Could not load nearby shops',
    () => (_db.select(
      _db.shops,
    )..orderBy([(shop) => OrderingTerm.asc(shop.position)])).watch(),
  );
}
