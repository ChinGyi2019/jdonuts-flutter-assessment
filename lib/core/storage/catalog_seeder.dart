import 'package:drift/drift.dart';
import 'package:fpdart/fpdart.dart';

import '../error/failure.dart';
import 'app_database.dart';
import 'catalog_seed.dart';
import 'local_result.dart';

final class CatalogSeeder {
  CatalogSeeder(this._db, this._loadSeed);

  static const _versionRow = 1;
  final AppDatabase _db;
  final Future<String> Function() _loadSeed;
  Future<Either<Failure, Unit>>? _initializing;
  Future<Either<Failure, Unit>>? _reconciling;
  bool _initialized = false;

  Future<Either<Failure, Unit>> ensureSeeded() {
    if (_initialized) return Future.value(right(unit));
    return _initializing ??= _initialize().whenComplete(
      () => _initializing = null,
    );
  }

  Future<Either<Failure, Unit>> reconcile() => _reconciling ??= localResult(
    'Could not refresh the catalog',
    _reconcile,
  ).whenComplete(() => _reconciling = null);

  Future<Unit> _reconcile() async {
    final seed = CatalogSeed.decode(await _loadSeed());
    final replaced = await _db.transaction(() => _writeIfNewer(seed));
    if (!replaced) {
      // A same-version refresh still re-runs the active Drift queries.
      _db.notifyUpdates(_db.allTables.map(TableUpdate.onTable).toSet());
    }
    _initialized = true;
    return unit;
  }

  Future<bool> _writeIfNewer(CatalogSeed seed) async {
    final stored = await _version().getSingleOrNull();
    if (stored != null && stored.revision >= seed.revision) return false;
    await _replaceCatalog(seed);
    await _db
        .into(_db.members)
        .insert(seed.member.toInsertable(), mode: InsertMode.insertOrIgnore);
    await _db
        .into(_db.catalogVersions)
        .insertOnConflictUpdate(
          CatalogVersionsCompanion.insert(
            id: const Value(_versionRow),
            revision: seed.revision,
          ),
        );
    return true;
  }

  Future<Either<Failure, Unit>> _initialize() async {
    final result = await reconcile();
    if (result.isRight()) return result;
    // An existing database can still be read if a newer bundle fails.
    final cached = await localResult(
      'Could not open the local catalog',
      () => _version().getSingleOrNull(),
    );
    _initialized = cached.getRight().toNullable() != null;
    return _initialized ? right(unit) : result;
  }

  Selectable<CatalogVersion> _version() =>
      _db.select(_db.catalogVersions)
        ..where((row) => row.id.equals(_versionRow));

  Future<void> _replaceCatalog(CatalogSeed seed) => _db.batch((batch) {
    batch.deleteAll(_db.sectionProducts);
    batch.deleteAll(_db.products);
    batch.deleteAll(_db.banners);
    batch.deleteAll(_db.shops);
    batch.deleteAll(_db.rewardTiers);
    batch.deleteAll(_db.rewardChallenges);
    batch.insertAll(
      _db.products,
      seed.products.map((row) => row.toInsertable()),
    );
    batch.insertAll(_db.banners, seed.banners.map((row) => row.toInsertable()));
    batch.insertAll(_db.shops, seed.shops.map((row) => row.toInsertable()));
    batch.insertAll(
      _db.rewardTiers,
      seed.tiers.map((row) => row.toInsertable()),
    );
    batch.insertAll(
      _db.rewardChallenges,
      seed.challenges.map((row) => row.toInsertable()),
    );
    batch.insertAll(
      _db.sectionProducts,
      seed.sections.map((row) => row.toInsertable()),
    );
  });
}
