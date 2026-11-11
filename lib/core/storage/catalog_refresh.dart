import 'package:fpdart/fpdart.dart';

import '../error/failure.dart';
import 'catalog_seeder.dart';

final class CatalogRefresh {
  CatalogRefresh({
    required CatalogSeeder seeder,
    required bool Function() isOnline,
    required Future<Either<Failure, Unit>> Function() refreshImages,
  }) : _seeder = seeder,
       _isOnline = isOnline,
       _refreshImages = refreshImages;

  final CatalogSeeder _seeder;
  final bool Function() _isOnline;
  final Future<Either<Failure, Unit>> Function() _refreshImages;
  Future<Either<Failure, Unit>>? _inFlight;

  Future<Either<Failure, Unit>> refresh() =>
      _inFlight ??= _refresh().whenComplete(() => _inFlight = null);

  Future<Either<Failure, Unit>> _refresh() async {
    final result = await _seeder.reconcile();
    if (result.isLeft() || !_isOnline()) return result;
    return _refreshImages();
  }
}
