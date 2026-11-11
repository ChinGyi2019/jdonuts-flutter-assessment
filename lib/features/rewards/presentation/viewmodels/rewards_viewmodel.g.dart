// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rewards_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(rewardsViewModel)
final rewardsViewModelProvider = RewardsViewModelProvider._();

final class RewardsViewModelProvider
    extends
        $FunctionalProvider<
          AsyncValue<RewardsState?>,
          AsyncValue<RewardsState?>,
          AsyncValue<RewardsState?>
        >
    with $Provider<AsyncValue<RewardsState?>> {
  RewardsViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'rewardsViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$rewardsViewModelHash();

  @$internal
  @override
  $ProviderElement<AsyncValue<RewardsState?>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AsyncValue<RewardsState?> create(Ref ref) {
    return rewardsViewModel(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<RewardsState?> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<RewardsState?>>(value),
    );
  }
}

String _$rewardsViewModelHash() => r'4967440fac3eeb86aa9ddbcaf22f9ce56b82e7b1';
