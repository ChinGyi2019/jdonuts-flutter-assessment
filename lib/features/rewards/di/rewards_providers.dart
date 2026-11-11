import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../app/active_member.dart';
import '../../../core/error/failure.dart';
import '../../../core/storage/storage_providers.dart';
import '../data/datasources/rewards_local_data_source.dart';
import '../data/repositories/rewards_repository_impl.dart';
import '../domain/entities/reward_challenge.dart';
import '../domain/entities/reward_tier.dart';
import '../domain/repositories/rewards_repository.dart';

part 'rewards_providers.g.dart';

@riverpod
RewardsLocalDataSource rewardsLocalDataSource(Ref ref) =>
    RewardsLocalDataSource(
      ref.watch(appDatabaseProvider),
      ref.watch(catalogSeederProvider),
    );

@riverpod
RewardsRepository rewardsRepository(Ref ref) =>
    RewardsRepositoryImpl(ref.watch(rewardsLocalDataSourceProvider));

@riverpod
Stream<Either<Failure, List<RewardTier>>> rewardTiers(Ref ref) =>
    ref.watch(rewardsRepositoryProvider).watchTiers();

@riverpod
Stream<Either<Failure, List<RewardChallenge>>> rewardChallenges(Ref ref) =>
    ref.watch(rewardsRepositoryProvider).watchChallenges();

@riverpod
AsyncValue<Either<Failure, TierProgress?>> memberTierProgress(Ref ref) {
  final member = ref.watch(activeMemberProvider);
  final tiers = ref.watch(rewardTiersProvider);
  return member.when(
    data: (result) => result.match(
      (failure) => AsyncData(left(failure)),
      (profile) => profile == null
          ? AsyncData(right(null))
          : tiers.whenData(
              (levels) => levels.map(
                (rows) => TierProgress.fromTiers(profile.points, rows),
              ),
            ),
    ),
    error: AsyncError.new,
    loading: AsyncLoading.new,
  );
}
