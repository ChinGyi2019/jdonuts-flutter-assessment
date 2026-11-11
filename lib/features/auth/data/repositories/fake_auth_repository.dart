import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/member/domain/member.dart';
import '../../../../core/member/domain/member_repository.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/registration_api.dart';

class FakeAuthRepository implements AuthRepository {
  FakeAuthRepository(
    this.members,
    this._registrationApi, {
    this.delay = const Duration(seconds: 1),
  });
  final MemberRepository members;
  final RegistrationApi _registrationApi;
  final Duration delay;

  @override
  Future<Either<Failure, Member?>> findMember(String phone) async {
    await Future<void>.delayed(delay);
    return members.findByPhone(phone);
  }

  @override
  Future<Either<Failure, bool>> verifyOtp(String otp) async {
    await Future<void>.delayed(delay);
    return right(otp == '123456');
  }

  @override
  Future<Either<Failure, Member>> register(
    MemberRegistration registration,
  ) async {
    final response = await _registrationApi.register(registration);
    return response.match(
      (failure) async => left(failure),
      (_) => members.register(registration),
    );
  }
}
