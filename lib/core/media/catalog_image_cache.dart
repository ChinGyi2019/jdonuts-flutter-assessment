import 'package:cached_network_image/cached_network_image.dart';
import 'package:fpdart/fpdart.dart';

import '../error/failure.dart';

final class CatalogImageCache {
  static const _downloadTimeout = Duration(seconds: 5);

  Future<Either<Failure, Unit>> refresh(Iterable<String> urls) async {
    var failed = false;
    for (final url in urls) {
      try {
        await CachedNetworkImageProvider.defaultCacheManager
            .downloadFile(url, force: true)
            .timeout(_downloadTimeout);
        await CachedNetworkImageProvider(url).evict();
      } catch (_) {
        failed = true;
      }
    }
    return failed
        ? left(const NetworkFailure('Could not refresh some catalog images'))
        : right(unit);
  }
}
