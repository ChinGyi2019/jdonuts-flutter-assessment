import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_local_data_source.dart';

final class ProductRepositoryImpl implements ProductRepository {
  ProductRepositoryImpl(this._local);

  final ProductLocalDataSource _local;

  @override
  Stream<Either<Failure, Product?>> watchById(String id) => _local
      .watchById(id)
      .map((result) => result.map((row) => row?.toEntity()));
}
