import 'dart:async';
import 'dart:typed_data';

import 'package:code_test_madivizion/core/connectivity/reachability_probe.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late Dio dio;
  late _ProbeAdapter adapter;
  late ReachabilityProbe probe;

  setUp(() {
    dio = Dio(BaseOptions(baseUrl: 'https://example.test'));
    adapter = _ProbeAdapter();
    dio.httpClientAdapter = adapter;
    probe = ReachabilityProbe(dio, timeout: const Duration(milliseconds: 100));
  });

  tearDown(() => dio.close(force: true));

  test('accepts the expected 204 without credentials or redirects', () async {
    expect(await probe.isReachable(), isTrue);
    expect(adapter.lastRequest!.path, '/generate_204');
    expect(adapter.lastRequest!.followRedirects, isFalse);
    expect(adapter.lastRequest!.headers, isNot(contains('Authorization')));
  });

  test('rejects captive portal pages and redirects', () async {
    adapter.status = 200;
    expect(await probe.isReachable(), isFalse);
    adapter.status = 302;
    expect(await probe.isReachable(), isFalse);
  });

  test('treats an unreachable host as offline', () async {
    adapter.unreachable = true;
    expect(await probe.isReachable(), isFalse);
  });

  test('cancels a probe that exceeds the overall deadline', () async {
    adapter.stall = true;
    expect(await probe.isReachable(), isFalse);
    expect(await adapter.cancelled.future, isTrue);
  });
}

class _ProbeAdapter implements HttpClientAdapter {
  int status = 204;
  bool unreachable = false;
  bool stall = false;
  RequestOptions? lastRequest;
  final cancelled = Completer<bool>();

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    lastRequest = options;
    if (unreachable) {
      throw DioException.connectionError(
        requestOptions: options,
        reason: 'No route to host',
      );
    }
    if (stall) {
      await cancelFuture!;
      cancelled.complete(true);
    }
    return ResponseBody.fromString('', status);
  }

  @override
  void close({bool force = false}) {}
}
