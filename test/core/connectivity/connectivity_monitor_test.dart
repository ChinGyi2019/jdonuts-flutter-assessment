import 'dart:async';

import 'package:code_test_madivizion/core/connectivity/connectivity_monitor.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late StreamController<List<ConnectivityResult>> transport;
  late ConnectivityMonitor monitor;
  late Future<bool> Function() probe;
  late int probeCalls;

  setUp(() {
    transport = StreamController.broadcast();
    probeCalls = 0;
    probe = () async => false;
    monitor = ConnectivityMonitor(
      transportChanges: transport.stream,
      readTransport: () async => [ConnectivityResult.wifi],
      probe: () {
        probeCalls++;
        return probe();
      },
    );
  });

  tearDown(() async {
    await monitor.close();
    await transport.close();
  });

  test('Wi-Fi can be offline and a recheck can detect restoration', () async {
    final states = expectLater(
      monitor.statuses,
      emitsInOrder([
        NetworkStatus.checking,
        NetworkStatus.offline,
        NetworkStatus.online,
      ]),
    );
    await monitor.recheck();
    expect(monitor.status, NetworkStatus.offline);
    probe = () async => true;
    await monitor.recheck();
    await states;
  });

  test('airplane mode skips HTTP and rejects a stale success', () async {
    final pendingProbe = Completer<bool>();
    probe = () => pendingProbe.future;
    monitor.resume();
    await Future<void>.delayed(Duration.zero);
    final offline = monitor.statuses.firstWhere(
      (status) => status == NetworkStatus.offline,
    );
    transport.add([ConnectivityResult.none]);
    await offline;
    pendingProbe.complete(true);
    await Future<void>.delayed(Duration.zero);

    expect(probeCalls, 1);
    expect(monitor.status, NetworkStatus.offline);
  });

  test('resume re-reads transport even without a transport event', () async {
    final firstOffline = monitor.statuses.firstWhere(
      (status) => status == NetworkStatus.offline,
    );
    monitor.resume();
    await firstOffline;
    monitor.pause();
    probe = () async => true;
    final online = monitor.statuses.firstWhere(
      (status) => status == NetworkStatus.online,
    );
    monitor.resume();
    expect(await online, NetworkStatus.online);
  });
}
