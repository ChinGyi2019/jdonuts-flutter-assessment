import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../network/api_client.dart';
import 'connectivity_monitor.dart';
import 'reachability_probe.dart';

part 'connectivity_providers.g.dart';

const _probeOrigin = 'https://connectivitycheck.gstatic.com';

@Riverpod(keepAlive: true)
ReachabilityProbe reachabilityProbe(Ref ref) {
  final dio = createApiClient(
    baseUri: Uri.parse(_probeOrigin),
    readToken: () async => null,
  );
  ref.onDispose(() => dio.close(force: true));
  return ReachabilityProbe(dio);
}

@Riverpod(keepAlive: true)
ConnectivityMonitor connectivityMonitor(Ref ref) {
  final connectivity = Connectivity();
  final probe = ref.watch(reachabilityProbeProvider);
  final monitor = ConnectivityMonitor(
    transportChanges: connectivity.onConnectivityChanged,
    readTransport: connectivity.checkConnectivity,
    probe: probe.isReachable,
  );
  final listener = AppLifecycleListener(
    onResume: monitor.resume,
    onPause: monitor.pause,
    onDetach: monitor.pause,
  );
  ref.onDispose(() {
    listener.dispose();
    unawaited(monitor.close());
  });
  monitor.resume();
  return monitor;
}

@Riverpod(keepAlive: true)
Stream<NetworkStatus> networkStatus(Ref ref) =>
    ref.watch(connectivityMonitorProvider).statuses;
