import 'package:code_test_madivizion/app/shell.dart';
import 'package:code_test_madivizion/core/theme/app_motion.dart';
import 'package:code_test_madivizion/core/theme/app_theme.dart';
import 'package:code_test_madivizion/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

void main() {
  for (final direction in TextDirection.values) {
    testWidgets('tab selection animates and can be interrupted in $direction', (
      tester,
    ) async {
      final reduceMotion = ValueNotifier(false);
      addTearDown(reduceMotion.dispose);
      final router = GoRouter(
        initialLocation: '/home',
        routes: [
          StatefulShellRoute.indexedStack(
            builder: (_, _, shell) => AppShell(navigationShell: shell),
            branches: [
              for (final path in [
                'home',
                'rewards',
                'discover',
                'orders',
                'settings',
              ])
                StatefulShellBranch(
                  routes: [
                    GoRoute(
                      path: '/$path',
                      builder: (_, _) => Text('$path screen'),
                    ),
                  ],
                ),
            ],
          ),
        ],
      );
      addTearDown(router.dispose);
      await tester.pumpWidget(
        MaterialApp.router(
          routerConfig: router,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          builder: (context, child) => ValueListenableBuilder<bool>(
            valueListenable: reduceMotion,
            builder: (context, reduced, child) => MediaQuery(
              data: MediaQuery.of(context).copyWith(disableAnimations: reduced),
              child: Directionality(textDirection: direction, child: child!),
            ),
            child: child,
          ),
        ),
      );
      await tester.pumpAndSettle();

      final pill = find.byWidgetPredicate(
        (widget) =>
            widget is DecoratedBox &&
            widget.decoration is ShapeDecoration &&
            (widget.decoration as ShapeDecoration).color ==
                AppColors.catalogPink,
      );
      double labelOpacity(String label) => tester
          .widget<Opacity>(
            find
                .ancestor(of: find.text(label), matching: find.byType(Opacity))
                .first,
          )
          .opacity;
      final homeCenter = tester.getCenter(pill).dx;
      final restingIconY = tester.getCenter(find.byIcon(LucideIcons.crown)).dy;

      await tester.tap(find.byIcon(LucideIcons.crown));
      await tester.pump();
      await tester.pump(AppMotion.standard ~/ 2);
      final midTransition = tester.getCenter(pill).dx;
      expect(
        midTransition,
        direction == TextDirection.ltr
            ? greaterThan(homeCenter)
            : lessThan(homeCenter),
      );
      expect(labelOpacity('Home'), allOf(greaterThan(0), lessThan(1)));
      expect(labelOpacity('Reward'), allOf(greaterThan(0), lessThan(1)));
      expect(
        tester.getCenter(find.byIcon(LucideIcons.crown)).dy,
        lessThan(restingIconY),
      );

      // A second selection starts from the current indicator position.
      await tester.tap(find.byIcon(LucideIcons.settings));
      await tester.pump();
      expect(tester.getCenter(pill).dx, closeTo(midTransition, .01));
      await tester.pumpAndSettle();
      expect(find.text('settings screen'), findsOneWidget);
      expect(find.text('Home'), findsNothing);
      expect(find.text('Reward'), findsNothing);
      expect(labelOpacity('Settings'), 1);

      router.go('/discover');
      await tester.pump();
      await tester.pump(AppMotion.standard ~/ 2);
      expect(labelOpacity('Discover'), lessThan(1));
      reduceMotion.value = true;
      await tester.pump();
      expect(labelOpacity('Discover'), 1);
      expect(find.text('Settings'), findsNothing);

      await tester.tap(find.byIcon(LucideIcons.wallet));
      await tester.pump();
      expect(find.text('orders screen'), findsOneWidget);
      expect(labelOpacity('Orders'), 1);
      expect(find.text('Discover'), findsNothing);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('navigation preserves its backdrop and bottom safe area', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(390, 844);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetViewPadding);
    addTearDown(tester.view.resetPadding);
    final router = GoRouter(
      initialLocation: '/home',
      routes: [
        StatefulShellRoute.indexedStack(
          builder: (_, _, shell) => AppShell(navigationShell: shell),
          branches: [
            for (final path in [
              'home',
              'rewards',
              'discover',
              'orders',
              'settings',
            ])
              StatefulShellBranch(
                routes: [
                  GoRoute(path: '/$path', builder: (_, _) => Text(path)),
                ],
              ),
          ],
        ),
      ],
    );
    addTearDown(router.dispose);

    for (final inset in [0.0, 34.0]) {
      tester.view.viewPadding = FakeViewPadding(bottom: inset);
      tester.view.padding = FakeViewPadding(bottom: inset);
      await tester.pumpWidget(
        MaterialApp.router(
          routerConfig: router,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
        ),
      );
      await tester.pumpAndSettle();

      final backdrop = find.byWidgetPredicate(
        (widget) =>
            widget is ColoredBox && widget.color == AppColors.catalogPink,
      );
      expect(backdrop, findsOneWidget);
      expect(tester.getBottomLeft(backdrop).dy, 844);
      final homeIcon = find.byIcon(LucideIcons.house);
      expect(tester.getBottomLeft(homeIcon).dy, lessThanOrEqualTo(844 - inset));
      expect(tester.takeException(), isNull);
    }

    tester.view.viewPadding = const FakeViewPadding(right: 80, bottom: 34);
    tester.view.padding = const FakeViewPadding(right: 80, bottom: 34);
    await tester.pumpAndSettle();
    Finder item(IconData icon) => find
        .ancestor(of: find.byIcon(icon), matching: find.byType(InkWell))
        .first;
    final first = tester.getRect(item(LucideIcons.house));
    final last = tester.getRect(item(LucideIcons.settings));
    expect((first.left + last.right) / 2, closeTo(195, .01));
    expect(last.right, lessThanOrEqualTo(390 - 80));
    for (final (icon, label) in [
      (LucideIcons.wallet, 'Orders'),
      (LucideIcons.settings, 'Settings'),
    ]) {
      await tester.tap(find.byIcon(icon));
      await tester.pumpAndSettle();
      expect(find.text(label.toLowerCase()), findsOneWidget);
      final labelFinder = find.text(label);
      final paragraph = tester.renderObject<RenderParagraph>(labelFinder);
      expect(paragraph.didExceedMaxLines, isFalse, reason: label);
      expect(tester.getRect(labelFinder).width, greaterThan(0));
      final left = tester.getRect(item(LucideIcons.house)).left;
      final right = tester.getRect(item(LucideIcons.settings)).right;
      expect((left + right) / 2, closeTo(195, .01));
    }
    expect(tester.takeException(), isNull);
  });
  testWidgets(
    'system back returns each other tab to home, then exits',
    (tester) async {
      final backHandling = <bool>[];
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        (call) async {
          if (call.method == 'SystemNavigator.setFrameworkHandlesBack') {
            backHandling.add(call.arguments as bool);
          }
          return null;
        },
      );
      addTearDown(
        () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
          SystemChannels.platform,
          null,
        ),
      );
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      final router = GoRouter(
        initialLocation: '/home',
        routes: [
          StatefulShellRoute.indexedStack(
            builder: (_, _, shell) => AppShell(navigationShell: shell),
            branches: [
              for (final path in [
                'home',
                'rewards',
                'discover',
                'orders',
                'settings',
              ])
                StatefulShellBranch(
                  routes: [
                    GoRoute(
                      path: '/$path',
                      builder: (_, _) => Center(child: Text('$path screen')),
                    ),
                  ],
                ),
            ],
          ),
        ],
      );
      addTearDown(router.dispose);
      await tester.pumpWidget(
        MaterialApp.router(
          routerConfig: router,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
        ),
      );
      await tester.pumpAndSettle();

      for (final path in ['rewards', 'discover', 'orders', 'settings']) {
        router.go('/$path');
        await tester.pumpAndSettle();
        expect(find.text('$path screen'), findsOneWidget);
        expect(
          backHandling.last,
          isTrue,
          reason: 'Android must send back to Flutter on $path',
        );
        expect(await tester.binding.handlePopRoute(), isTrue);
        await tester.pumpAndSettle();
        expect(find.text('home screen'), findsOneWidget);
      }
      expect(backHandling.last, isFalse);
      expect(await tester.binding.handlePopRoute(), isFalse);
    },
    variant: const TargetPlatformVariant({TargetPlatform.android}),
  );
}
