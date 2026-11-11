import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

enum NetworkStatus { checking, offline, online }

final class ConnectivityMonitor {
  ConnectivityMonitor({
    required Stream<List<ConnectivityResult>> transportChanges,
    required Future<List<ConnectivityResult>> Function() readTransport,
    required Future<bool> Function() probe,
    this.pollInterval = const Duration(seconds: 30),
  }) : _transportChanges = transportChanges,
       _readTransport = readTransport,
       _probe = probe;

  final Stream<List<ConnectivityResult>> _transportChanges;
  final Future<List<ConnectivityResult>> Function() _readTransport;
  final Future<bool> Function() _probe;
  final Duration pollInterval;

  final _statuses = StreamController<NetworkStatus>.broadcast();
  NetworkStatus _status = NetworkStatus.checking;
  StreamSubscription<List<ConnectivityResult>>? _subscription;
  Timer? _poll;
  int _generation = 0;

  NetworkStatus get status => _status;

  Stream<NetworkStatus> get statuses => Stream.multi((listener) {
    listener.add(_status);
    final subscription = _statuses.stream.listen(
      listener.add,
      onDone: listener.close,
    );
    listener.onCancel = subscription.cancel;
  });

  void resume() {
    if (_subscription != null) return;
    _subscription = _transportChanges.listen(
      (transports) => unawaited(_evaluate(transports, ++_generation)),
      onError: (Object _) => _transportFailed(),
    );
    unawaited(recheck());
    _poll = Timer.periodic(pollInterval, (_) => unawaited(recheck()));
  }

  void pause() {
    ++_generation;
    _poll?.cancel();
    unawaited(_subscription?.cancel());
    _subscription = null;
  }

  Future<void> recheck() async {
    final generation = ++_generation;
    try {
      final transports = await _readTransport();
      await _evaluate(transports, generation);
    } catch (_) {
      _publish(NetworkStatus.offline, generation);
    }
  }

  Future<void> _evaluate(
    List<ConnectivityResult> transports,
    int generation,
  ) async {
    if (generation != _generation) return;
    final hasTransport = transports.any(
      (value) => value != ConnectivityResult.none,
    );
    try {
      final reachable = hasTransport && await _probe();
      _publish(
        reachable ? NetworkStatus.online : NetworkStatus.offline,
        generation,
      );
    } catch (_) {
      _publish(NetworkStatus.offline, generation);
    }
  }

  void _transportFailed() => _publish(NetworkStatus.offline, ++_generation);

  void _publish(NetworkStatus status, int generation) {
    if (_status == status || _generation != generation || _statuses.isClosed) {
      return;
    }
    _status = status;
    _statuses.add(status);
  }

  Future<void> close() async {
    pause();
    await _statuses.close();
  }
}
