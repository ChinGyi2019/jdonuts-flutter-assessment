import 'package:code_test_madivizion/core/error/failure.dart';
import 'package:code_test_madivizion/core/member/domain/member.dart';
import 'package:code_test_madivizion/core/member/domain/member_repository.dart';
import 'package:code_test_madivizion/features/auth/data/datasources/registration_api.dart';
import 'package:code_test_madivizion/features/auth/data/repositories/fake_auth_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';

class FailingMembers implements MemberRepository {
  @override
  Future<Either<Failure, Member?>> findByPhone(String phone) async =>
      left(const StorageFailure('read failed'));
  @override
  Future<Either<Failure, Member>> register(
    MemberRegistration registration,
  ) async => left(const StorageFailure('write failed'));
  @override
  Stream<Either<Failure, Member?>> watch(String memberId) =>
      const Stream.empty();
}

void main() {
  test(
    'forwards member storage failures and accepts only the fake code',
    () async {
      final client = createMockRegistrationClient(delay: Duration.zero);
      addTearDown(client.close);
      final repository = FakeAuthRepository(
        FailingMembers(),
        RegistrationApi(client),
        delay: Duration.zero,
      );
      expect(
        (await repository.findMember('+959254135592')).getLeft().toNullable(),
        isA<StorageFailure>(),
      );
      final registration = MemberRegistration(
        phone: '+959254135592',
        firstName: 'Aye',
        birthDate: DateTime(2000),
      );
      expect(
        (await repository.register(registration)).getLeft().toNullable(),
        isA<StorageFailure>(),
      );
      expect(
        (await repository.verifyOtp('123456')).getRight().toNullable(),
        isTrue,
      );
      expect(
        (await repository.verifyOtp('000000')).getRight().toNullable(),
        isFalse,
      );
    },
  );

  test('posts the registration profile to the mock endpoint', () async {
    final client = createMockRegistrationClient(delay: Duration.zero);
    addTearDown(client.close);
    final responses = <Response<dynamic>>[];
    client.interceptors.add(
      InterceptorsWrapper(
        onResponse: (response, handler) {
          responses.add(response);
          handler.next(response);
        },
      ),
    );

    final result = await RegistrationApi(client).register(
      MemberRegistration(
        phone: '+959254135592',
        firstName: 'Aye',
        birthDate: DateTime(2000, 2, 29),
      ),
    );

    expect(result.isRight(), isTrue);
    final response = responses.single;
    expect(response.statusCode, 201);
    expect(response.requestOptions.method, 'POST');
    expect(response.requestOptions.uri.path, '/register');
    expect(response.requestOptions.data, {
      'phone': '+959254135592',
      'firstName': 'Aye',
      'lastName': null,
      'birthDate': '2000-02-29',
    });
  });
}
