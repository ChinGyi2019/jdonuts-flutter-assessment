import 'package:drift/drift.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/storage/app_database.dart';
import '../../../../core/storage/catalog_queries.dart';
import '../../../../core/storage/catalog_seeder.dart';
import '../models/reward_models.dart';

class RewardsLocalDataSource {
  RewardsLocalDataSource(this._db, this._seeder);

  final AppDatabase _db;
  final CatalogSeeder _seeder;

  Stream<Either<Failure, List<TierModel>>> watchTiers() => watchLocal(
    _seeder,
    'Could not load reward tiers',
    () => (_db.select(
      _db.rewardTiers,
    )..orderBy([(tier) => OrderingTerm.asc(tier.minimumPoints)])).watch(),
  );

  Stream<Either<Failure, List<ChallengeModel>>> watchChallenges() => watchLocal(
    _seeder,
    'Could not load reward challenges',
    () => (_db.select(
      _db.rewardChallenges,
    )..orderBy([(challenge) => OrderingTerm.asc(challenge.position)])).watch(),
  );
}
