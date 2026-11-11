import 'package:dio/dio.dart';

import '../network/api_client.dart';

final class ReachabilityProbe {
  const ReachabilityProbe(
    this._dio, {
    this.timeout = const Duration(seconds: 3),
  });

  final Dio _dio;
  final Duration timeout;

  Future<bool> isReachable() async {
    final cancel = CancelToken();
    final result = await request(
      () => _dio
          .get<void>(
            '/generate_204',
            cancelToken: cancel,
            options: Options(
              followRedirects: false,
              validateStatus: (status) => status == 204,
              receiveTimeout: timeout,
            ),
          )
          .timeout(
            timeout,
            onTimeout: () {
              cancel.cancel('Reachability check timed out');
              throw DioException.requestCancelled(
                requestOptions: RequestOptions(path: '/generate_204'),
                reason: 'Reachability check timed out',
              );
            },
          ),
    );
    return result.isRight();
  }
}
