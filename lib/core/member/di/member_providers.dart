import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../storage/storage_providers.dart';
import '../data/member_local_data_source.dart';
import '../data/member_repository_impl.dart';
import '../domain/member_repository.dart';

part 'member_providers.g.dart';

@riverpod
MemberLocalDataSource memberLocalDataSource(Ref ref) => MemberLocalDataSource(
  ref.watch(appDatabaseProvider),
  ref.watch(catalogSeederProvider),
);

@riverpod
MemberRepository memberRepository(Ref ref) =>
    MemberRepositoryImpl(ref.watch(memberLocalDataSourceProvider));
