import 'dart:async';

import 'package:code_test_madivizion/app/active_member.dart';
import 'package:code_test_madivizion/app/session.dart';
import 'package:code_test_madivizion/core/error/failure.dart';
import 'package:code_test_madivizion/core/media/catalog_image.dart';
import 'package:code_test_madivizion/core/media/image_reference.dart';
import 'package:code_test_madivizion/core/member/domain/member.dart';
import 'package:code_test_madivizion/core/theme/app_theme.dart';
import 'package:code_test_madivizion/core/storage/hive_settings.dart';
import 'package:code_test_madivizion/core/storage/storage_providers.dart';
import 'package:code_test_madivizion/features/settings/presentation/viewmodels/language_preference.dart';
import 'package:code_test_madivizion/core/widgets/skeleton.dart';
import 'package:code_test_madivizion/features/rewards/di/rewards_providers.dart';
import 'package:code_test_madivizion/features/rewards/domain/entities/reward_tier.dart';
import 'package:code_test_madivizion/features/settings/presentation/views/settings_screen.dart';
import 'package:code_test_madivizion/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';

import '../../app/router_test.dart' show FakeSessionStore;

const _member = Member(
  id: 'member-1',
  firstName: 'Hania',
  lastName: 'Aung',
  phone: '+959254135592',
  points: 680000,
  notificationCount: 0,
  rewardsBadgeCount: 0,
  image: ImageReference(asset: 'assets/images/coconut-donut.webp'),
);

void main() {
  testWidgets('switches language and restores the saved choice', (
    tester,
  ) async {
    final settings = _FakeSettings();
    await tester.pumpWidget(_screen(settings: settings));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('language_toggle')));
    await tester.pumpAndSettle();
    expect(find.text('ဆက်တင်များ'), findsOneWidget);
    expect(settings.values['language_code'], 'my');

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpWidget(_screen(settings: settings));
    await tester.pumpAndSettle();
    expect(find.text('ဆက်တင်များ'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('language_toggle')));
    await tester.pumpAndSettle();
    expect(find.text('Settings'), findsOneWidget);
    expect(settings.values['language_code'], 'en');
  });

  testWidgets('reports a failed language save without changing locale', (
    tester,
  ) async {
    final settings = _FakeSettings()..failWrites = true;
    await tester.pumpWidget(_screen(settings: settings));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('language_toggle')));
    await tester.pumpAndSettle();
    expect(find.text('Settings'), findsOneWidget);
    expect(find.text('Could not save language. Try again.'), findsOneWidget);
  });

  testWidgets('shows the profile and pink logout button on a small screen', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 568);
    tester.view.devicePixelRatio = 1;
    tester.platformDispatcher.textScaleFactorTestValue = 2;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await tester.pumpWidget(_screen());
    await tester.pumpAndSettle();

    expect(find.text(_member.displayName), findsOneWidget);
    expect(find.text(_member.phone!), findsOneWidget);
    expect(find.text('Silver member'), findsOneWidget);
    expect(find.text('680,000 reward points'), findsOneWidget);
    expect(
      tester.widget<CatalogImage>(find.byType(CatalogImage)).reference,
      _member.image,
    );
    await tester.scrollUntilVisible(
      find.text('Log out'),
      160,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.ensureVisible(find.text('Log out'));
    await tester.pumpAndSettle();
    final button = find.ancestor(
      of: find.text('Log out'),
      matching: find.bySubtype<FilledButton>(),
    );
    final style = tester.widget<FilledButton>(button).style!;
    expect(style.backgroundColor!.resolve({}), AppColors.catalogPink);
    expect(find.text('Log out').hitTestable(), findsOneWidget);

    await tester.tap(button);
    await tester.pumpAndSettle();
    expect(
      find.widgetWithText(ElevatedButton, 'Log out').hitTestable(),
      findsOneWidget,
    );
    expect(
      find.widgetWithText(ElevatedButton, 'Cancel').hitTestable(),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('shows a loading placeholder and recovers after profile retry', (
    tester,
  ) async {
    final first = Completer<Either<Failure, Member?>>();
    var reads = 0;
    await tester.pumpWidget(
      _screen(
        loadMember: () => ++reads == 1
            ? Stream.fromFuture(first.future)
            : Stream.value(right(_member)),
      ),
    );
    expect(find.byType(SkeletonShimmer), findsOneWidget);
    first.complete(left(const StorageFailure('Profile unavailable')));
    await tester.pumpAndSettle();
    expect(find.text('Could not load your member profile.'), findsOneWidget);

    await tester.tap(find.text('Try again'));
    await tester.pumpAndSettle();
    expect(find.text(_member.displayName), findsOneWidget);
    expect(find.byType(SkeletonShimmer), findsNothing);
    expect(reads, 2);
  });

  testWidgets('confirms logout and allows retry after failure', (tester) async {
    final store = _DeferredSessionStore();
    await tester.pumpWidget(_screen(store: store));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Log out'));
    await tester.pumpAndSettle();
    expect(find.text('Log out of your account?'), findsOneWidget);
    expect(
      find.text('You’ll need to sign in again to access your account.'),
      findsOneWidget,
    );
    final cancel = find.widgetWithText(ElevatedButton, 'Cancel');
    final confirm = find.widgetWithText(ElevatedButton, 'Log out');
    expect(
      tester.widget<ElevatedButton>(cancel).style?.backgroundColor?.resolve({}),
      Colors.grey.shade300,
    );
    expect(
      tester
          .widget<ElevatedButton>(confirm)
          .style
          ?.backgroundColor
          ?.resolve({}),
      AppColors.catalogPink,
    );
    expect(store.clearCalls, 0);
    await tester.tap(cancel);
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsNothing);
    expect(store.clearCalls, 0);

    await tester.tap(find.text('Log out'));
    await tester.pumpAndSettle();
    await tester.tap(confirm);
    await tester.pump();
    final button = find.bySubtype<FilledButton>();
    expect(tester.widget<FilledButton>(button).onPressed, isNull);
    expect(find.text('Logging out…'), findsOneWidget);
    expect(store.clearCalls, 1);

    store.clearing.completeError(StateError('Could not clear storage'));
    await tester.pumpAndSettle();
    expect(find.text('Couldn’t log out. Try again.'), findsOneWidget);
    expect(tester.widget<FilledButton>(button).onPressed, isNotNull);
    expect(find.text(_member.displayName), findsOneWidget);
  });
}

Widget _screen({
  Stream<Either<Failure, Member?>> Function()? loadMember,
  SessionStore? store,
  _FakeSettings? settings,
}) => ProviderScope(
  overrides: [
    hiveSettingsProvider.overrideWithValue(settings ?? _FakeSettings()),
    if (store != null) sessionStoreProvider.overrideWithValue(store),
    activeMemberProvider.overrideWith(
      (_) => loadMember?.call() ?? Stream.value(right(_member)),
    ),
    rewardTiersProvider.overrideWith(
      (_) => Stream.value(
        right(const [
          RewardTier(id: 'silver', name: 'Silver', minimumPoints: 678500),
        ]),
      ),
    ),
  ],
  child: Consumer(
    builder: (context, ref, _) => MaterialApp(
      locale: ref.watch(languagePreferenceProvider).asData?.value,
      theme: AppTheme.light,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const SettingsScreen(),
    ),
  ),
);

class _DeferredSessionStore extends FakeSessionStore {
  _DeferredSessionStore() : super(Future.value(_member.id));

  final clearing = Completer<void>();
  int clearCalls = 0;

  @override
  Future<void> clear() {
    clearCalls++;
    return clearing.future;
  }
}

class _FakeSettings implements HiveSettings {
  final values = <String, Object?>{};
  bool failWrites = false;

  @override
  Future<Either<Failure, T?>> read<T>(String key) async =>
      right(values[key] as T?);

  @override
  Future<Either<Failure, Unit>> write<T>(String key, T value) async {
    if (failWrites) return left(const StorageFailure('Write failed'));
    values[key] = value;
    return right(unit);
  }

  @override
  Future<void> close() async {}
}
