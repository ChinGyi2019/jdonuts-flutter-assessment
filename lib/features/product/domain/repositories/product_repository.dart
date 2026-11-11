import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../entities/product.dart';

abstract interface class ProductRepository {
  Stream<Either<Failure, Product?>> watchById(String id);
}
