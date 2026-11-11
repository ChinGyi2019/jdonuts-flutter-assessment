import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/member/domain/member.dart';
import '../../../../core/network/api_client.dart';

const _registrationPath = '/register';

class RegistrationApi {
  RegistrationApi(this._client);

  final Dio _client;

  Future<Either<Failure, void>> register(MemberRegistration profile) =>
      request(() async {
        await _client.post<void>(
          _registrationPath,
          data: {
            'phone': profile.phone,
            'firstName': profile.firstName,
            'lastName': profile.lastName,
            'birthDate': profile.birthDate.toIso8601String().split('T').first,
          },
        );
      });
}

Dio createMockRegistrationClient({
  Duration delay = const Duration(seconds: 1),
}) => createApiClient(
  baseUri: Uri.parse('https://auth.invalid'),
  readToken: () async => null,
)..httpClientAdapter = _MockRegistrationAdapter(delay);

class _MockRegistrationAdapter implements HttpClientAdapter {
  _MockRegistrationAdapter(this._delay);

  final Duration _delay;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    if (options.method != 'POST' || options.uri.path != _registrationPath) {
      return ResponseBody.fromString('', 404);
    }
    await Future<void>.delayed(_delay);
    return ResponseBody.fromString('', 201);
  }

  @override
  void close({bool force = false}) {}
}
