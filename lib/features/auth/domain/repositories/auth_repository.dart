import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/member/domain/member.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, Member?>> findMember(String phone);
  Future<Either<Failure, bool>> verifyOtp(String otp);
  Future<Either<Failure, Member>> register(MemberRegistration registration);
}
