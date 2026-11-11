import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract interface class SessionStore {
  Future<String?> readMemberId();
  Future<void> writeMemberId(String memberId);
  Future<void> clear();
}

class SecureSessionStore implements SessionStore {
  const SecureSessionStore(this._storage);
  static const _key = 'active_member_id';
  final FlutterSecureStorage _storage;

  @override
  Future<String?> readMemberId() => _storage.read(key: _key);
  @override
  Future<void> writeMemberId(String memberId) =>
      _storage.write(key: _key, value: memberId);
  @override
  Future<void> clear() => _storage.delete(key: _key);
}

final sessionStoreProvider = Provider<SessionStore>(
  (ref) => const SecureSessionStore(FlutterSecureStorage()),
);

final sessionProvider = AsyncNotifierProvider<SessionController, String?>(
  SessionController.new,
);

class SessionController extends AsyncNotifier<String?> {
  @override
  Future<String?> build() => ref.read(sessionStoreProvider).readMemberId();

  Future<void> signIn(String memberId) async {
    if (memberId.trim().isEmpty) {
      throw ArgumentError.value(memberId, 'memberId');
    }
    await ref.read(sessionStoreProvider).writeMemberId(memberId);
    state = AsyncData(memberId);
  }

  Future<void> signOut() async {
    await ref.read(sessionStoreProvider).clear();
    state = const AsyncData(null);
  }
}
