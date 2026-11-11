import 'dart:convert';
import 'dart:ui' as ui;

import 'package:code_test_madivizion/app/app.dart';
import 'package:code_test_madivizion/app/session.dart';
import 'package:code_test_madivizion/core/connectivity/connectivity_monitor.dart';
import 'package:code_test_madivizion/core/connectivity/connectivity_providers.dart';
import 'package:code_test_madivizion/core/storage/app_database.dart';
import 'package:code_test_madivizion/core/storage/storage_providers.dart';
import 'package:code_test_madivizion/core/theme/app_theme.dart';
import 'package:code_test_madivizion/features/auth/presentation/views/welcome_screen.dart';
import 'package:code_test_madivizion/features/product/presentation/widgets/product_artwork.dart';
import 'package:code_test_madivizion/l10n/app_localizations.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  for (final reduced in [false, true]) {
    testWidgets(
      'compact artwork and seasonal navigation, reduced motion: $reduced',
      (tester) async {
        tester.view.devicePixelRatio = 1;
        tester.view.physicalSize = const Size(320, 568);
        tester.view.padding = const FakeViewPadding(top: 24, bottom: 16);
        tester.view.viewPadding = const FakeViewPadding(top: 24, bottom: 16);
        tester.platformDispatcher.textScaleFactorTestValue = 1.3;
        tester.platformDispatcher.accessibilityFeaturesTestValue =
            FakeAccessibilityFeatures(disableAnimations: reduced);
        addTearDown(tester.view.reset);
        addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
        addTearDown(
          tester.platformDispatcher.clearAccessibilityFeaturesTestValue,
        );
        final boundary = GlobalKey();
        Future<void> capture(String name) async {
          if (!const bool.fromEnvironment('ARTWORK_CAPTURE')) return;
          final render =
              boundary.currentContext!.findRenderObject()!
                  as RenderRepaintBoundary;
          final image = await render.toImage(pixelRatio: 2);
          final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
          final encoded = base64Encode(bytes!.buffer.asUint8List());
          // Full PNG data is printed only when the review flag is enabled.
          // ignore: avoid_print
          print(
            'ARTWORK_DATA:${reduced ? 'reduced' : 'motion'}_$name:$encoded',
          );
          image.dispose();
        }

        await tester.pumpWidget(
          RepaintBoundary(
            key: boundary,
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              home: WelcomeScreen(onExplore: () {}),
            ),
          ),
        );
        await tester.pump(const Duration(seconds: 3));
        await capture('welcome');
        final database = AppDatabase(NativeDatabase.memory());
        addTearDown(database.close);
        await tester.pumpWidget(
          RepaintBoundary(
            key: boundary,
            child: ProviderScope(
              overrides: [
                appDatabaseProvider.overrideWithValue(database),
                sessionStoreProvider.overrideWithValue(_Session()),
                networkStatusProvider.overrideWith(
                  (_) => Stream.value(NetworkStatus.offline),
                ),
              ],
              child: const MainApp(),
            ),
          ),
        );
        await _wait(tester, find.text('Silver member'));
        await tester.pumpAndSettle();
        await capture('home');
        for (final name in [
          'Mistletoe Romance Box',
          'Christmas Mix Family Box',
        ]) {
          final product = find.text(name);
          await tester.scrollUntilVisible(
            find.text('Seasonal specials'),
            160,
            scrollable: find.byType(Scrollable).first,
          );
          await Scrollable.ensureVisible(
            tester.element(product),
            alignment: 0.5,
          );
          await tester.pumpAndSettle();
          await capture(
            name.startsWith('Mistletoe') ? 'home_seasonal' : 'home_family',
          );
          await tester.tap(product);
          await tester.pump(const Duration(milliseconds: 120));
          await capture(
            name.startsWith('Mistletoe') ? 'flight_mistletoe' : 'flight_family',
          );
          await tester.pumpAndSettle();
          expect(
            find.text(name.startsWith('Mistletoe') ? 'JD041001' : 'JD041002'),
            findsOneWidget,
          );
          await capture(
            name.startsWith('Mistletoe') ? 'detail_mistletoe' : 'detail_family',
          );
          await tester.ensureVisible(find.byType(ProductArtwork).last);
          await tester.pumpAndSettle();
          await capture(
            name.startsWith('Mistletoe') ? 'image_mistletoe' : 'image_family',
          );
          await tester.tap(find.byIcon(LucideIcons.arrowLeft));
          await tester.pumpAndSettle();
        }
        await tester.tap(find.byIcon(LucideIcons.crown));
        await _wait(tester, find.text('680,000'));
        await tester.pumpAndSettle();
        final rewardsButton = find
            .ancestor(
              of: find.byIcon(LucideIcons.crown),
              matching: find.byType(InkWell),
            )
            .first;
        final navLabel = find.descendant(
          of: rewardsButton,
          matching: find.text('Reward'),
        );
        expect(
          tester.renderObject<RenderParagraph>(navLabel).didExceedMaxLines,
          isFalse,
        );
        final pill = find.byWidgetPredicate(
          (widget) =>
              widget is DecoratedBox &&
              widget.decoration is ShapeDecoration &&
              (widget.decoration as ShapeDecoration).color ==
                  AppColors.catalogPink,
        );
        final pillRect = tester.getRect(pill);
        final labelRect = tester.getRect(navLabel);
        expect(pillRect.contains(labelRect.topLeft), isTrue);
        expect(pillRect.contains(labelRect.bottomRight), isTrue);
        await capture('rewards');
        await tester.drag(find.byType(Scrollable).first, const Offset(0, -350));
        await tester.pumpAndSettle();
        await capture('rewards_challenges');
        await tester.scrollUntilVisible(
          find.text('9/12'),
          120,
          scrollable: find.byType(Scrollable).first,
        );
        await tester.pumpAndSettle();
        await capture('rewards_coffee');
        expect(tester.takeException(), isNull);
        await tester.pumpWidget(const SizedBox.shrink());
      },
    );
  }
}

Future<void> _wait(WidgetTester tester, Finder finder) async {
  for (var i = 0; i < 60 && finder.evaluate().isEmpty; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
  expect(finder, findsWidgets);
}

class _Session implements SessionStore {
  @override
  Future<String?> readMemberId() async => 'member_demo';
  @override
  Future<void> writeMemberId(String memberId) async {}
  @override
  Future<void> clear() async {}
}
