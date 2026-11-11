import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../../features/home/data/models/home_catalog_models.dart';
import '../../features/home/domain/entities/home_catalog.dart';
import '../../features/product/data/models/product_model.dart';
import '../../features/rewards/data/models/reward_models.dart';
import '../../features/rewards/domain/entities/reward_challenge.dart';
import '../member/data/member_model.dart';
import 'app_tables.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Products,
    Banners,
    Shops,
    SectionProducts,
    Members,
    RewardTiers,
    RewardChallenges,
    CatalogVersions,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openDatabase());

  static QueryExecutor _openDatabase() {
    if (kIsWeb) {
      return LazyDatabase(
        () => throw UnsupportedError('Drift requires SQLite WASM on web'),
      );
    }
    return driftDatabase(
      name: 'jdonuts',
      native: const DriftNativeOptions(shareAcrossIsolates: true),
    );
  }

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (migrator) => migrator.createAll(),
    onUpgrade: (migrator, from, to) async {
      if (from == 1 && to == 2) {
        await transaction(() async {
          await migrator.createTable(rewardChallenges);
          // Force a catalog reconciliation so the new table is seeded.
          await update(
            catalogVersions,
          ).write(const CatalogVersionsCompanion(revision: Value(0)));
        });
        return;
      }
      throw StateError('Unsupported database migration: $from to $to');
    },
    beforeOpen: (_) => customStatement('PRAGMA foreign_keys = ON'),
  );
}
