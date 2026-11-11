import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../../domain/entities/reward_challenge.dart';
import '../../domain/entities/reward_tier.dart';
import '../../domain/repositories/rewards_repository.dart';
import '../datasources/rewards_local_data_source.dart';

final class RewardsRepositoryImpl implements RewardsRepository {
  RewardsRepositoryImpl(this._local);

  final RewardsLocalDataSource _local;

  @override
  Stream<Either<Failure, List<RewardTier>>> watchTiers() =>
      _local.watchTiers().map(
        (result) => result.map(
          (rows) => List.unmodifiable(rows.map((row) => row.toEntity())),
        ),
      );

  @override
  Stream<Either<Failure, List<RewardChallenge>>> watchChallenges() =>
      _local.watchChallenges().map(
        (result) => result.map(
          (rows) => List.unmodifiable(rows.map((row) => row.toEntity())),
        ),
      );
}
