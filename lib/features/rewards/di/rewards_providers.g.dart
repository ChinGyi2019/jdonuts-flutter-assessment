// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rewards_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(rewardsLocalDataSource)
final rewardsLocalDataSourceProvider = RewardsLocalDataSourceProvider._();

final class RewardsLocalDataSourceProvider
    extends
        $FunctionalProvider<
          RewardsLocalDataSource,
          RewardsLocalDataSource,
          RewardsLocalDataSource
        >
    with $Provider<RewardsLocalDataSource> {
  RewardsLocalDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'rewardsLocalDataSourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$rewardsLocalDataSourceHash();

  @$internal
  @override
  $ProviderElement<RewardsLocalDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  RewardsLocalDataSource create(Ref ref) {
    return rewardsLocalDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RewardsLocalDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RewardsLocalDataSource>(value),
    );
  }
}

String _$rewardsLocalDataSourceHash() =>
    r'4077b5aca7827a50f375e09621be784bc2164c99';

@ProviderFor(rewardsRepository)
final rewardsRepositoryProvider = RewardsRepositoryProvider._();

final class RewardsRepositoryProvider
    extends
        $FunctionalProvider<
          RewardsRepository,
          RewardsRepository,
          RewardsRepository
        >
    with $Provider<RewardsRepository> {
  RewardsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'rewardsRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$rewardsRepositoryHash();

  @$internal
  @override
  $ProviderElement<RewardsRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  RewardsRepository create(Ref ref) {
    return rewardsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RewardsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RewardsRepository>(value),
    );
  }
}

String _$rewardsRepositoryHash() => r'536b70dced2b2d07a9a4aaa2d6b7d2d128b84d52';

@ProviderFor(rewardTiers)
final rewardTiersProvider = RewardTiersProvider._();

final class RewardTiersProvider
    extends
        $FunctionalProvider<
          AsyncValue<Either<Failure, List<RewardTier>>>,
          Either<Failure, List<RewardTier>>,
          Stream<Either<Failure, List<RewardTier>>>
        >
    with
        $FutureModifier<Either<Failure, List<RewardTier>>>,
        $StreamProvider<Either<Failure, List<RewardTier>>> {
  RewardTiersProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'rewardTiersProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$rewardTiersHash();

  @$internal
  @override
  $StreamProviderElement<Either<Failure, List<RewardTier>>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<Either<Failure, List<RewardTier>>> create(Ref ref) {
    return rewardTiers(ref);
  }
}

String _$rewardTiersHash() => r'279fde06cf1e362c0cfe46814ae3b8a5a2f75a8a';

@ProviderFor(rewardChallenges)
final rewardChallengesProvider = RewardChallengesProvider._();

final class RewardChallengesProvider
    extends
        $FunctionalProvider<
          AsyncValue<Either<Failure, List<RewardChallenge>>>,
          Either<Failure, List<RewardChallenge>>,
          Stream<Either<Failure, List<RewardChallenge>>>
        >
    with
        $FutureModifier<Either<Failure, List<RewardChallenge>>>,
        $StreamProvider<Either<Failure, List<RewardChallenge>>> {
  RewardChallengesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'rewardChallengesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$rewardChallengesHash();

  @$internal
  @override
  $StreamProviderElement<Either<Failure, List<RewardChallenge>>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<Either<Failure, List<RewardChallenge>>> create(Ref ref) {
    return rewardChallenges(ref);
  }
}

String _$rewardChallengesHash() => r'fe79208e312f64571b5148de3bda9e260f68437a';

@ProviderFor(memberTierProgress)
final memberTierProgressProvider = MemberTierProgressProvider._();

final class MemberTierProgressProvider
    extends
        $FunctionalProvider<
          AsyncValue<Either<Failure, TierProgress?>>,
          AsyncValue<Either<Failure, TierProgress?>>,
          AsyncValue<Either<Failure, TierProgress?>>
        >
    with $Provider<AsyncValue<Either<Failure, TierProgress?>>> {
  MemberTierProgressProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'memberTierProgressProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$memberTierProgressHash();

  @$internal
  @override
  $ProviderElement<AsyncValue<Either<Failure, TierProgress?>>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AsyncValue<Either<Failure, TierProgress?>> create(Ref ref) {
    return memberTierProgress(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<Either<Failure, TierProgress?>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride:
          $SyncValueProvider<AsyncValue<Either<Failure, TierProgress?>>>(value),
    );
  }
}

String _$memberTierProgressHash() =>
    r'98d439385634d3424546904440e25afcec86cf50';
