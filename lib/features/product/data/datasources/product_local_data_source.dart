import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/storage/app_database.dart';
import '../../../../core/storage/catalog_queries.dart';
import '../../../../core/storage/catalog_seeder.dart';
import '../models/product_model.dart';

class ProductLocalDataSource {
  ProductLocalDataSource(this._db, this._seeder);

  final AppDatabase _db;
  final CatalogSeeder _seeder;

  Stream<Either<Failure, ProductModel?>> watchById(String id) => watchLocal(
    _seeder,
    'Could not load the product',
    () => (_db.select(
      _db.products,
    )..where((product) => product.id.equals(id))).watchSingleOrNull(),
  );
}
