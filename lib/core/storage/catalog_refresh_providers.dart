import 'dart:async';

import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../connectivity/connectivity_monitor.dart';
import '../connectivity/connectivity_providers.dart';
import '../error/failure.dart';
import '../media/catalog_image_cache.dart';
import 'app_database.dart';
import 'catalog_refresh.dart';
import 'local_result.dart';
import 'storage_providers.dart';

part 'catalog_refresh_providers.g.dart';

@Riverpod(keepAlive: true)
CatalogRefresh catalogRefresh(Ref ref) {
  final seeder = ref.watch(catalogSeederProvider);
  final monitor = ref.watch(connectivityMonitorProvider);
  final database = ref.watch(appDatabaseProvider);
  final images = CatalogImageCache();
  final refresh = CatalogRefresh(
    seeder: seeder,
    isOnline: () => monitor.status == NetworkStatus.online,
    refreshImages: () => _refreshImages(database, images),
  );
  unawaited(seeder.ensureSeeded());
  ref.listen(networkStatusProvider, (previous, next) {
    if (next.value == NetworkStatus.online &&
        previous?.value != NetworkStatus.online) {
      unawaited(refresh.refresh());
    }
  }, fireImmediately: true);
  return refresh;
}

Future<Either<Failure, Unit>> _refreshImages(
  AppDatabase database,
  CatalogImageCache cache,
) async {
  final urls = await localResult('Could not load catalog image URLs', () async {
    final rows = await database.customSelect('''
      SELECT image_url FROM products
      UNION SELECT image_url FROM banners
      UNION SELECT image_url FROM shops
      UNION SELECT image_url FROM members
      UNION SELECT image_url FROM reward_challenges
    ''').get();
    return rows.map((row) => row.readNullable<String>('image_url')).nonNulls;
  });
  return urls.match((failure) async => left(failure), cache.refresh);
}
