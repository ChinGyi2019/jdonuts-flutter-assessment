import 'dart:async';

import 'package:flutter/services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'app_database.dart';
import 'catalog_seeder.dart';
import 'hive_settings.dart';

part 'storage_providers.g.dart';

@Riverpod(keepAlive: true)
AppDatabase appDatabase(Ref ref) {
  final database = AppDatabase();
  ref.onDispose(() => unawaited(database.close()));
  return database;
}

@Riverpod(keepAlive: true)
CatalogSeeder catalogSeeder(Ref ref) => CatalogSeeder(
  ref.watch(appDatabaseProvider),
  () => rootBundle.loadString('assets/data/catalog.json', cache: false),
);

@Riverpod(keepAlive: true)
HiveSettings hiveSettings(Ref ref) {
  final settings = HiveSettings();
  ref.onDispose(() => unawaited(settings.close()));
  return settings;
}
