import 'dart:async';

import 'package:code_test_madivizion/app/active_member.dart';
import 'package:code_test_madivizion/app/app.dart';
import 'package:code_test_madivizion/app/router.dart';
import 'package:code_test_madivizion/app/session.dart';
import 'package:code_test_madivizion/core/connectivity/connectivity_monitor.dart';
import 'package:code_test_madivizion/core/connectivity/connectivity_providers.dart';
import 'package:code_test_madivizion/features/home/presentation/views/home_screen.dart';
import 'package:code_test_madivizion/features/product/di/product_providers.dart';
import 'package:code_test_madivizion/features/settings/presentation/views/settings_screen.dart';
import 'package:fpdart/fpdart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

class FakeSessionStore implements SessionStore {
  FakeSessionStore(this.restoration);
  final Future<String?> restoration;
  String? saved;
  @override
  Future<String?> readMemberId() => restoration;
  @override
  Future<void> writeMemberId(String memberId) async => saved = memberId;
  @override
  Future<void> clear() async => saved = null;
}

void main() {
  testWidgets('restores a protected product link without showing onboarding', (
    tester,
  ) async {
    final restored = Completer<String?>();
    final container = ProviderContainer(
      overrides: [
        sessionStoreProvider.overrideWithValue(
          FakeSessionStore(restored.future),
        ),
        productByIdProvider(
          'p_coconut',
        ).overrideWith((_) => Stream.value(right(null))),
      ],
    );
    addTearDown(container.dispose);
    final router = container.read(routerProvider);
    router.go('/product/p_coconut');
    await tester.pumpWidget(
      UncontrolledProviderScope(container: container, child: const MainApp()),
    );
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('Round food for every mood'), findsNothing);
    restored.complete('member-1');
    await tester.pumpAndSettle();
    expect(
      router.routeInformationProvider.value.uri.path,
      '/product/p_coconut',
    );
    expect(find.text('This product could not be found.'), findsOneWidget);
  });

  testWidgets(
    'restores a protected route on first login and resets the shell on logout',
    (tester) async {
      tester.platformDispatcher.accessibilityFeaturesTestValue =
          const FakeAccessibilityFeatures(disableAnimations: true);
      addTearDown(
        tester.platformDispatcher.clearAccessibilityFeaturesTestValue,
      );
      final store = FakeSessionStore(Future.value(null));
      final container = ProviderContainer(
        overrides: [
          sessionStoreProvider.overrideWithValue(store),
          networkStatusProvider.overrideWith(
            (_) => Stream.value(NetworkStatus.online),
          ),
          activeMemberProvider.overrideWith((_) => Stream.value(right(null))),
        ],
      );
      addTearDown(container.dispose);
      await tester.pumpWidget(
        UncontrolledProviderScope(container: container, child: const MainApp()),
      );
      await tester.pumpAndSettle();
      final router = container.read(routerProvider);
      router.go('/rewards');
      await tester.pumpAndSettle();
      expect(find.text('Round food for every mood'), findsOneWidget);
      await container.read(sessionProvider.notifier).signIn('member-1');
      await tester.pumpAndSettle();
      expect(find.text('J’ Donuts Rewards'), findsOneWidget);
      router.go('/settings');
      await tester.pumpAndSettle();
      final shell = tester.state(find.byType(StatefulNavigationShell));
      await tester.tap(find.text('Log out'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(ElevatedButton, 'Log out'));
      await tester.pumpAndSettle();
      expect(store.saved, isNull);
      expect(find.text('Round food for every mood'), findsOneWidget);
      expect(shell.mounted, isFalse);
      expect(
        router.routeInformationProvider.value.uri,
        Uri.parse('/onboarding'),
      );
      expect(router.canPop(), isFalse);

      await container.read(sessionProvider.notifier).signIn('member-1');
      await tester.pumpAndSettle();
      expect(find.byType(HomeScreen), findsOneWidget);
      expect(find.byType(SettingsScreen, skipOffstage: false), findsNothing);
      expect(router.canPop(), isFalse);
    },
  );
}
