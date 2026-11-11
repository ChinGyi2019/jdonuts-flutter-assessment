import 'package:fpdart/fpdart.dart';

import '../../error/failure.dart';
import '../domain/member.dart';
import '../domain/member_repository.dart';
import 'member_local_data_source.dart';

final class MemberRepositoryImpl implements MemberRepository {
  MemberRepositoryImpl(this._local);

  final MemberLocalDataSource _local;

  @override
  Stream<Either<Failure, Member?>> watch(String memberId) => _local
      .watch(memberId)
      .map((result) => result.map((row) => row?.toEntity()));

  @override
  Future<Either<Failure, Member?>> findByPhone(String normalizedPhone) async =>
      (await _local.findByPhone(normalizedPhone)).map((row) => row?.toEntity());

  @override
  Future<Either<Failure, Member>> register(
    MemberRegistration registration,
  ) async => (await _local.register(registration)).map((row) => row.toEntity());
}
