import 'dart:async';

import 'package:code_test_madivizion/core/error/failure.dart';
import 'package:code_test_madivizion/core/storage/app_database.dart';
import 'package:code_test_madivizion/core/storage/catalog_refresh.dart';
import 'package:code_test_madivizion/core/storage/catalog_seeder.dart';
import 'package:drift/native.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
    'coalesces concurrent calls and preserves catalog rows when images fail',
    () async {
      final database = AppDatabase(NativeDatabase.memory());
      addTearDown(database.close);
      final bundle = await rootBundle.loadString('assets/data/catalog.json');
      final seeder = CatalogSeeder(database, () async => bundle);
      final images = Completer<Either<Failure, Unit>>();
      var imageRefreshes = 0;
      final refresh = CatalogRefresh(
        seeder: seeder,
        isOnline: () => true,
        refreshImages: () {
          imageRefreshes++;
          return images.future;
        },
      );

      final manual = refresh.refresh();
      final reconnect = refresh.refresh();
      expect(reconnect, same(manual));
      images.complete(left(const NetworkFailure('Image fetch failed')));
      expect((await reconnect).getLeft().toNullable(), isA<NetworkFailure>());
      expect(imageRefreshes, 1);
      expect(await database.select(database.products).get(), isNotEmpty);
    },
  );

  test('manual offline refresh can seed without downloading images', () async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    final bundle = await rootBundle.loadString('assets/data/catalog.json');
    final seeder = CatalogSeeder(database, () async => bundle);
    final refresh = CatalogRefresh(
      seeder: seeder,
      isOnline: () => false,
      refreshImages: () async =>
          fail('Offline refresh requested remote images'),
    );

    expect((await refresh.refresh()).isRight(), isTrue);
    expect(await database.select(database.products).get(), isNotEmpty);
  });
}
