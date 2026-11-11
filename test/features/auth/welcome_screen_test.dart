import 'package:code_test_madivizion/core/theme/app_motion.dart';
import 'package:code_test_madivizion/features/auth/presentation/views/welcome_screen.dart';
import 'package:code_test_madivizion/features/auth/presentation/widgets/donut_artwork.dart';
import 'package:code_test_madivizion/features/auth/presentation/widgets/donut_circle.dart';
import 'package:code_test_madivizion/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('fills a wide viewport and keeps Explore above the safe inset', (
    tester,
  ) async {
    const viewport = Size(1024, 400);
    const safeInsets = FakeViewPadding(top: 32, bottom: 48);
    tester.view.physicalSize = viewport;
    tester.view.devicePixelRatio = 1;
    tester.view.padding = safeInsets;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: WelcomeScreen(onExplore: () {}),
      ),
    );
    await tester.pump(const Duration(seconds: 2));

    final artwork = tester.getRect(find.byType(DonutArtwork));
    expect(artwork.topLeft, Offset.zero);
    expect(artwork.width, viewport.width);

    final explore = tester.getRect(find.byType(FilledButton));
    expect(explore.center.dx, viewport.width / 2);
    expect(explore.width, lessThan(viewport.width));
    expect(
      explore.bottom,
      lessThanOrEqualTo(viewport.height - safeInsets.bottom),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'loops the left column up and the right column down, honoring Reduce Motion',
    (tester) async {
      tester.view.physicalSize = const Size(320, 568);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      var explored = false;
      final reducedMotion = ValueNotifier(false);
      addTearDown(reducedMotion.dispose);
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          builder: (context, child) => ValueListenableBuilder(
            valueListenable: reducedMotion,
            child: child,
            builder: (context, reduce, child) => MediaQuery(
              data: MediaQuery.of(context).copyWith(
                disableAnimations: reduce,
                textScaler: const TextScaler.linear(1.3),
              ),
              child: child!,
            ),
          ),
          home: WelcomeScreen(onExplore: () => explored = true),
        ),
      );

      await tester.pump(const Duration(seconds: 2));
      final left = _visibleCircle(tester, DonutCircleStyle.aqua);
      final right = _visibleCircle(tester, DonutCircleStyle.lavender);
      expect(tester.widget<DonutCircle>(left).rectangular, isTrue);
      expect(
        tester.getSize(left).height,
        greaterThan(tester.getSize(left).width),
      );
      final leftStart = tester.getCenter(left);
      final rightStart = tester.getCenter(right);
      expect(leftStart.dx, lessThan(rightStart.dx));
      expect(leftStart.dy, lessThan(rightStart.dy));

      await tester.pump(const Duration(seconds: 1));
      final leftMoved = tester.getCenter(left);
      final rightMoved = tester.getCenter(right);
      expect(leftMoved.dx, leftStart.dx);
      expect(rightMoved.dx, rightStart.dx);
      expect(leftMoved.dy, lessThan(leftStart.dy));
      expect(rightMoved.dy, greaterThan(rightStart.dy));

      await tester.pump(AppMotion.welcomeScroll);
      expect(tester.getCenter(left).dy, closeTo(leftMoved.dy, .01));
      expect(tester.getCenter(right).dy, closeTo(rightMoved.dy, .01));

      reducedMotion.value = true;
      await tester.pumpAndSettle();
      final leftPaused = tester.getCenter(left);
      final rightPaused = tester.getCenter(right);
      await tester.pump(const Duration(seconds: 5));
      expect(tester.getCenter(left), leftPaused);
      expect(tester.getCenter(right), rightPaused);

      await tester.tap(find.text('LET’S EXPLORE'));
      expect(explored, isTrue);
      expect(tester.takeException(), isNull);
    },
  );
}

Finder _visibleCircle(WidgetTester tester, DonutCircleStyle style) {
  final artwork = tester.getRect(find.byType(DonutArtwork));
  final matches = find.byWidgetPredicate(
    (widget) => widget is DonutCircle && widget.style == style,
  );
  return List.generate(
    matches.evaluate().length,
    matches.at,
  ).firstWhere((circle) => artwork.contains(tester.getCenter(circle)));
}
