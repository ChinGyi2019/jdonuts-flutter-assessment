import 'package:code_test_madivizion/app/session.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'stores and restores a session through the iOS Keychain',
    (tester) async {
      final store = SecureSessionStore(
        FlutterSecureStorage(
          iOptions: IOSOptions(
            accountName:
                'session-integration-test-${DateTime.now().microsecondsSinceEpoch}',
          ),
        ),
      );
      final overrides = [sessionStoreProvider.overrideWithValue(store)];
      final firstLaunch = ProviderContainer(overrides: overrides);
      addTearDown(firstLaunch.dispose);
      expect(await firstLaunch.read(sessionProvider.future), isNull);
      addTearDown(store.clear);
      await firstLaunch.read(sessionProvider.notifier).signIn('test-member');

      final nextLaunch = ProviderContainer(overrides: overrides);
      addTearDown(nextLaunch.dispose);
      expect(await nextLaunch.read(sessionProvider.future), 'test-member');

      await nextLaunch.read(sessionProvider.notifier).signOut();
      expect(await store.readMemberId(), isNull);
    },
    skip: kIsWeb || defaultTargetPlatform != TargetPlatform.iOS,
  );
}
