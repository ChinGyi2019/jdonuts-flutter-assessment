import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../../../product/domain/entities/product.dart';
import '../entities/home_catalog.dart';

abstract interface class HomeCatalogRepository {
  Stream<Either<Failure, List<HomeBanner>>> watchBanners();
  Stream<Either<Failure, List<Product>>> watchSection(HomeSection section);
  Stream<Either<Failure, List<Shop>>> watchShops();
}
