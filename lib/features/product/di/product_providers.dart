import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/error/failure.dart';
import '../../../core/storage/storage_providers.dart';
import '../data/datasources/product_local_data_source.dart';
import '../data/repositories/product_repository_impl.dart';
import '../domain/entities/product.dart';
import '../domain/repositories/product_repository.dart';

part 'product_providers.g.dart';

@riverpod
ProductLocalDataSource productLocalDataSource(Ref ref) =>
    ProductLocalDataSource(
      ref.watch(appDatabaseProvider),
      ref.watch(catalogSeederProvider),
    );

@riverpod
ProductRepository productRepository(Ref ref) =>
    ProductRepositoryImpl(ref.watch(productLocalDataSourceProvider));

@riverpod
Stream<Either<Failure, Product?>> productById(Ref ref, String id) =>
    ref.watch(productRepositoryProvider).watchById(id);
