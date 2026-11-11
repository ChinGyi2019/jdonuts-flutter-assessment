import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../core/error/failure.dart';
import '../core/member/di/member_providers.dart';
import '../core/member/domain/member.dart';
import 'session.dart';

part 'active_member.g.dart';

@riverpod
Stream<Either<Failure, Member?>> activeMember(Ref ref) {
  final repository = ref.watch(memberRepositoryProvider);
  final session = ref.watch(sessionProvider);
  return Stream.fromFuture(
    session.when(
      data: Future.value,
      error: Future.error,
      loading: () => ref.watch(sessionProvider.future),
    ),
  ).asyncExpand(
    (id) => id == null ? Stream.value(right(null)) : repository.watch(id),
  );
}
