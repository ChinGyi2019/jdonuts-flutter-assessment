import 'package:code_test_madivizion/app/app.dart';
import 'package:code_test_madivizion/app/session.dart';
import 'package:code_test_madivizion/core/connectivity/connectivity_monitor.dart';
import 'package:code_test_madivizion/core/connectivity/connectivity_providers.dart';
import 'package:code_test_madivizion/core/storage/app_database.dart';
import 'package:code_test_madivizion/core/storage/storage_providers.dart';
import 'package:code_test_madivizion/features/home/domain/entities/home_catalog.dart';
import 'package:code_test_madivizion/features/home/presentation/widgets/home_product_section.dart';
import 'package:code_test_madivizion/features/settings/presentation/viewmodels/language_preference.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'registers, explores the offline catalog, and opens Coconut Donut',
    (tester) async {
      final database = AppDatabase(NativeDatabase.memory());
      addTearDown(database.close);
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            appDatabaseProvider.overrideWithValue(database),
            sessionStoreProvider.overrideWithValue(_TestSessionStore()),
            languagePreferenceProvider.overrideWith(
              _EnglishLanguagePreference.new,
            ),
            networkStatusProvider.overrideWith(
              (_) => Stream.value(NetworkStatus.offline),
            ),
          ],
          child: const MainApp(),
        ),
      );

      await _register(tester);
      expect(find.text('Welcome to the world of J’donuts'), findsOneWidget);
      await _finishWelcomeEntrance(tester);
      await tester.tap(find.text('LET’S EXPLORE'));

      await _waitFor(tester, find.text('Silver member'));
      expect(
        find.text('500 points left to become Gold Member'),
        findsOneWidget,
      );
      expect(find.text('You’re offline'), findsOneWidget);
      await tester.pumpAndSettle();

      await _openCoconutDonut(tester);
      await _waitFor(tester, find.text('JD022123'));
      expect(find.text('New'), findsOneWidget);
      expect(find.text('3,200 MMK'), findsNWidgets(2));
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('Increase quantity'));
      await _waitFor(tester, find.text('6,400 MMK'));
      await tester.pumpWidget(const SizedBox.shrink());
    },
  );
}

class _EnglishLanguagePreference extends LanguagePreference {
  @override
  Future<Locale?> build() async => const Locale('en');
}

Future<void> _register(WidgetTester tester) async {
  final start = find.text('LET’S GET STARTED');
  await _waitFor(tester, start);
  await tester.tap(start);
  await _waitFor(tester, find.widgetWithText(TextField, 'Mobile number'));
  await tester.enterText(find.byType(TextField), '09254135592');

  await _continue(tester);
  final otp = find.byKey(const ValueKey('otp-input'));
  await _waitFor(tester, otp);
  await tester.enterText(otp, '123456');

  await _continue(tester);
  final firstName = find.widgetWithText(TextField, 'First Name');
  await _waitFor(tester, firstName);
  await tester.enterText(firstName, 'Hania');

  await _continue(tester);
  final month = find.text('Month');
  await _waitFor(tester, month);
  await tester.ensureVisible(month);
  await tester.tap(month);
  final select = find.widgetWithText(FilledButton, 'SELECT');
  await _waitFor(tester, select);
  await tester.pumpAndSettle();
  await tester.tap(select);
  await _continue(tester);

  await _waitFor(tester, find.text('LET’S EXPLORE'));
}

Future<void> _finishWelcomeEntrance(WidgetTester tester) async {
  for (var frame = 0; frame < 15; frame++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
}

Future<void> _continue(WidgetTester tester) async {
  FocusManager.instance.primaryFocus?.unfocus();
  await tester.pumpAndSettle();
  final button = find.widgetWithText(FilledButton, 'CONTINUE');
  await tester.ensureVisible(button);
  await tester.tap(button);
  await tester.pump();
}

Future<void> _openCoconutDonut(WidgetTester tester) async {
  final more = find.byTooltip('More in Popular 🔥');
  await tester.scrollUntilVisible(
    more,
    260,
    scrollable: find.byType(Scrollable).first,
  );
  await tester.tap(more);
  await tester.pumpAndSettle();
  final coconut = find.descendant(
    of: find.byWidgetPredicate(
      (widget) =>
          widget is HomeProductSection && widget.section == HomeSection.popular,
    ),
    matching: find.text('Coconut Donut'),
  );
  await tester.ensureVisible(coconut);
  await tester.tap(coconut);
}

Future<void> _waitFor(WidgetTester tester, Finder finder) async {
  for (var attempt = 0; attempt < 60; attempt++) {
    await tester.pump(const Duration(milliseconds: 100));
    if (finder.evaluate().isNotEmpty) return;
  }
  expect(finder, findsWidgets);
}

final class _TestSessionStore implements SessionStore {
  String? _memberId;

  @override
  Future<String?> readMemberId() async => _memberId;

  @override
  Future<void> writeMemberId(String memberId) async => _memberId = memberId;

  @override
  Future<void> clear() async => _memberId = null;
}
