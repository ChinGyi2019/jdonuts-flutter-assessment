import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../entities/reward_challenge.dart';
import '../entities/reward_tier.dart';

abstract interface class RewardsRepository {
  Stream<Either<Failure, List<RewardTier>>> watchTiers();
  Stream<Either<Failure, List<RewardChallenge>>> watchChallenges();
}
