import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../app/active_member.dart';
import '../../../../core/error/failure.dart';
import '../../di/rewards_providers.dart';
import '../../domain/entities/reward_challenge.dart';
import '../../domain/entities/reward_tier.dart';

part 'rewards_viewmodel.g.dart';

final class RewardsState {
  const RewardsState({
    required this.badgeCount,
    required this.progress,
    required this.tiers,
    required this.challenges,
  });

  final int badgeCount;
  final TierProgress progress;
  final List<RewardTier> tiers;
  final List<RewardChallenge> challenges;
}

@riverpod
AsyncValue<RewardsState?> rewardsViewModel(Ref ref) {
  final member = _read(ref.watch(activeMemberProvider));
  if (member.hasError) {
    return AsyncError(member.error!, member.stackTrace!);
  }
  if (!member.hasValue) return const AsyncLoading();
  final profile = member.requireValue;
  if (profile == null) return const AsyncData(null);

  final progress = _read(ref.watch(memberTierProgressProvider));
  final tiers = _read(ref.watch(rewardTiersProvider));
  final challenges = _read(ref.watch(rewardChallengesProvider));
  if (challenges.hasError) {
    return AsyncError(challenges.error!, challenges.stackTrace!);
  }
  if (!challenges.hasValue) return const AsyncLoading();
  return progress.whenData((value) {
    if (value == null) return null;
    return RewardsState(
      badgeCount: profile.rewardsBadgeCount,
      progress: value,
      tiers: List.unmodifiable(tiers.requireValue),
      challenges: List.unmodifiable(challenges.requireValue),
    );
  });
}

AsyncValue<T> _read<T>(AsyncValue<Either<Failure, T>> source) => source.when(
  data: (result) => result.match(
    (failure) => AsyncError(failure, StackTrace.current),
    AsyncData.new,
  ),
  error: AsyncError.new,
  loading: AsyncLoading.new,
);
