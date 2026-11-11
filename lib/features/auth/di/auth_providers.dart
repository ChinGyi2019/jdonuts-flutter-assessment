import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/member/di/member_providers.dart';
import '../data/datasources/registration_api.dart';
import '../data/repositories/fake_auth_repository.dart';
import '../domain/repositories/auth_repository.dart';

part 'auth_providers.g.dart';

@riverpod
AuthRepository authRepository(Ref ref) {
  final members = ref.watch(memberRepositoryProvider);
  final client = createMockRegistrationClient();
  ref.onDispose(client.close);
  return FakeAuthRepository(members, RegistrationApi(client));
}
