import 'package:fpdart/fpdart.dart';

import '../../error/failure.dart';
import 'member.dart';

abstract interface class MemberRepository {
  Stream<Either<Failure, Member?>> watch(String memberId);
  Future<Either<Failure, Member?>> findByPhone(String normalizedPhone);
  Future<Either<Failure, Member>> register(MemberRegistration registration);
}
