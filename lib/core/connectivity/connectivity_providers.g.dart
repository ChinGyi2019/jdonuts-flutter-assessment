// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'connectivity_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(reachabilityProbe)
final reachabilityProbeProvider = ReachabilityProbeProvider._();

final class ReachabilityProbeProvider
    extends
        $FunctionalProvider<
          ReachabilityProbe,
          ReachabilityProbe,
          ReachabilityProbe
        >
    with $Provider<ReachabilityProbe> {
  ReachabilityProbeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'reachabilityProbeProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$reachabilityProbeHash();

  @$internal
  @override
  $ProviderElement<ReachabilityProbe> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ReachabilityProbe create(Ref ref) {
    return reachabilityProbe(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ReachabilityProbe value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ReachabilityProbe>(value),
    );
  }
}

String _$reachabilityProbeHash() => r'293e3170c55c7c1fef51c36cc9685caa43480b22';

@ProviderFor(connectivityMonitor)
final connectivityMonitorProvider = ConnectivityMonitorProvider._();

final class ConnectivityMonitorProvider
    extends
        $FunctionalProvider<
          ConnectivityMonitor,
          ConnectivityMonitor,
          ConnectivityMonitor
        >
    with $Provider<ConnectivityMonitor> {
  ConnectivityMonitorProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'connectivityMonitorProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$connectivityMonitorHash();

  @$internal
  @override
  $ProviderElement<ConnectivityMonitor> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ConnectivityMonitor create(Ref ref) {
    return connectivityMonitor(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ConnectivityMonitor value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ConnectivityMonitor>(value),
    );
  }
}

String _$connectivityMonitorHash() =>
    r'2a48d541df4d6a045399d14f94aeb41882a16537';

@ProviderFor(networkStatus)
final networkStatusProvider = NetworkStatusProvider._();

final class NetworkStatusProvider
    extends
        $FunctionalProvider<
          AsyncValue<NetworkStatus>,
          NetworkStatus,
          Stream<NetworkStatus>
        >
    with $FutureModifier<NetworkStatus>, $StreamProvider<NetworkStatus> {
  NetworkStatusProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'networkStatusProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$networkStatusHash();

  @$internal
  @override
  $StreamProviderElement<NetworkStatus> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<NetworkStatus> create(Ref ref) {
    return networkStatus(ref);
  }
}

String _$networkStatusHash() => r'be2a6d172441d11a8715d54859d5bbc5f0f393ce';
