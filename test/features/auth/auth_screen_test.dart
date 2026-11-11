import 'package:code_test_madivizion/app/router.dart';
import 'package:code_test_madivizion/app/session.dart';
import 'package:code_test_madivizion/core/error/failure.dart';
import 'package:code_test_madivizion/core/media/image_reference.dart';
import 'package:code_test_madivizion/core/member/domain/member.dart';
import 'package:code_test_madivizion/core/theme/app_theme.dart';
import 'package:code_test_madivizion/features/auth/di/auth_providers.dart';
import 'package:fpdart/fpdart.dart';
import 'package:code_test_madivizion/features/auth/presentation/views/auth_screen.dart';
import 'package:code_test_madivizion/features/auth/presentation/viewmodels/auth_state.dart';
import 'package:code_test_madivizion/features/auth/presentation/viewmodels/auth_viewmodel.dart';
import 'package:code_test_madivizion/features/auth/presentation/widgets/donut_artwork.dart';
import 'package:code_test_madivizion/features/auth/presentation/widgets/auth_visuals.dart';
import 'package:code_test_madivizion/l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'auth_viewmodel_test.dart' show StubAuth;
import '../../app/router_test.dart' show FakeSessionStore;

class RegistrationAuth extends StubAuth {
  int registrations = 0;

  @override
  Future<Either<Failure, Member>> register(MemberRegistration value) async {
    registrations++;
    await Future<void>.delayed(const Duration(seconds: 1));
    return right(
      Member(
        id: 'member-1',
        firstName: value.firstName,
        lastName: value.lastName,
        phone: value.phone,
        birthDate: value.birthDate,
        points: 0,
        notificationCount: 0,
        rewardsBadgeCount: 0,
        image: const ImageReference(asset: 'placeholder'),
      ),
    );
  }
}

class _PhoneAuthViewModel extends AuthViewModel {
  @override
  AuthState build() =>
      const AuthState(step: AuthStep.phone, mode: AuthMode.login);
}

class _BirthDateAuthViewModel extends AuthViewModel {
  @override
  AuthState build() => const AuthState(
    step: AuthStep.birthDate,
    phone: '+959254135592',
    firstName: 'Aye',
  );
}

void main() {
  testWidgets('tapping the phone field requests the phone keyboard', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authViewModelProvider.overrideWith(_PhoneAuthViewModel.new),
        ],
        child: const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: AuthScreen(),
        ),
      ),
    );

    await tester.tap(find.byType(TextField));
    await tester.pump();

    expect(
      tester.widget<TextField>(find.byType(TextField)).focusNode!.hasFocus,
      isTrue,
    );
    expect(tester.testTextInput.isVisible, isTrue);
    expect(
      tester.testTextInput.setClientArgs!['inputType']['name'],
      'TextInputType.phone',
    );
  });

  testWidgets('login offers registration for an unknown phone number', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [authRepositoryProvider.overrideWithValue(StubAuth())],
        child: const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: AuthScreen(),
        ),
      ),
    );
    await tester.tap(find.text('Log In'));
    await tester.pumpAndSettle();
    final button = find.widgetWithText(FilledButton, 'CONTINUE');
    expect(tester.widget<FilledButton>(button).onPressed, isNull);
    await tester.enterText(find.byType(TextField), '09254135592');
    await tester.pump();
    await tester.tap(button);
    await tester.pumpAndSettle();
    expect(find.text('Number not registered.'), findsOneWidget);
    await tester.tap(find.text('Register'));
    await tester.pumpAndSettle();
    expect(find.text('09254135592'), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets(
    'phone continue stays disabled for invalid input and validates on blur',
    (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [authRepositoryProvider.overrideWithValue(StubAuth())],
          child: const MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: AuthScreen(),
          ),
        ),
      );
      await tester.tap(find.text('Log In'));
      await tester.pumpAndSettle();

      final button = find.widgetWithText(FilledButton, 'CONTINUE');
      expect(tester.widget<FilledButton>(button).onPressed, isNull);

      // Typing an invalid number and clicking continue
      await tester.enterText(find.byType(TextField), '12345');
      await tester.pump();
      tester.widget<TextField>(find.byType(TextField)).focusNode!.unfocus();
      await tester.pumpAndSettle();

      // If failed, continue button stays disabled and inline message appears once field loses focus
      expect(tester.widget<FilledButton>(button).onPressed, isNull);
      expect(
        find.text('Phone number must start with 09 or 9.'),
        findsOneWidget,
      );

      // User types a valid number
      await tester.enterText(find.byType(TextField), '09254135592');
      await tester.pump();
      // Continue button is re-enabled
      expect(tester.widget<FilledButton>(button).onPressed, isNotNull);
      expect(find.text('Phone number must start with 09 or 9.'), findsNothing);

      // Clicking continue changes form to +959254135592 and advances
      await tester.tap(button);
      await tester.pumpAndSettle();
      expect(find.text('Number not registered.'), findsOneWidget);
    },
  );
  for (final (locale, continueLabel, error) in [
    (const Locale('en'), 'CONTINUE', 'Phone number must start with 09 or 9.'),
    (
      const Locale('my'),
      'ဆက်လက်လုပ်ဆောင်ရန်',
      'ဖုန်းနံပါတ်သည် 09 သို့မဟုတ် 9 ဖြင့် စရပါမည်။',
    ),
  ]) {
    testWidgets('validates phone prefix in ${locale.languageCode}', (
      tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authRepositoryProvider.overrideWithValue(StubAuth()),
            authViewModelProvider.overrideWith(_PhoneAuthViewModel.new),
          ],
          child: MaterialApp(
            locale: locale,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: const AuthScreen(),
          ),
        ),
      );
      final button = find.widgetWithText(FilledButton, continueLabel);
      await tester.enterText(find.byType(TextField), '123456789');
      tester.widget<TextField>(find.byType(TextField)).focusNode!.unfocus();
      await tester.pumpAndSettle();
      expect(find.text(error), findsOneWidget);
      expect(tester.widget<FilledButton>(button).onPressed, isNull);
      await tester.enterText(find.byType(TextField), '9254135592');
      await tester.pump();
      expect(find.text(error), findsNothing);
      expect(tester.widget<FilledButton>(button).onPressed, isNotNull);
      await tester.tap(button);
      await tester.pumpAndSettle();
      expect(find.byType(TextField), findsOneWidget);
      expect(
        find.text(
          locale.languageCode == 'en'
              ? 'Number not registered.'
              : 'ဤနံပါတ်ဖြင့် အကောင့်မရှိသေးပါ။',
        ),
        findsOneWidget,
      );
    });
  }

  testWidgets('shows the countdown and advances registration to birth date', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [authRepositoryProvider.overrideWithValue(StubAuth())],
        child: const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: AuthScreen(),
        ),
      ),
    );
    await tester.tap(find.text('LET’S GET STARTED'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), '09254135592');
    await tester.pump();
    await tester.tap(find.widgetWithText(FilledButton, 'CONTINUE'));
    await tester.pumpAndSettle();
    final countdown = tester.widget<Text>(
      find.byWidgetPredicate(
        (widget) =>
            widget is Text &&
            (widget.textSpan?.toPlainText().contains('\nresend in ') ?? false),
      ),
    );
    final spans = (countdown.textSpan! as TextSpan).children!;
    expect(spans, hasLength(4));
    final timer = spans[2] as TextSpan;
    expect(timer.text, matches(RegExp(r'^\d+:\d{2}$')));
    expect(timer.style?.color, AppColors.authTimer);
    expect((spans.first as TextSpan).style, isNull);
    expect((spans.last as TextSpan).style, isNull);

    await tester.enterText(find.byKey(const ValueKey('otp-input')), '123456');
    await tester.pump();
    expect(find.text('1'), findsOneWidget);
    expect(find.text('6'), findsOneWidget);
    await tester.tap(find.widgetWithText(FilledButton, 'CONTINUE'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.widgetWithText(TextField, 'First Name'),
      '  Aye  ',
    );
    await tester.pump();
    await tester.tap(find.widgetWithText(FilledButton, 'CONTINUE'));
    await tester.pumpAndSettle();
    expect(find.text('What’s your date of birth?'), findsOneWidget);
  });

  testWidgets('birthday fields share a picker and validate the selected date', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 568);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final store = FakeSessionStore(Future.value(null));
    final repository = RegistrationAuth();
    final container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(repository),
        authViewModelProvider.overrideWith(_BirthDateAuthViewModel.new),
        sessionStoreProvider.overrideWithValue(store),
      ],
    );
    addTearDown(container.dispose);
    await container.read(sessionProvider.future);
    final router = container.read(routerProvider);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp.router(
          routerConfig: router,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(
              context,
            ).copyWith(textScaler: const TextScaler.linear(1.3)),
            child: child!,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    final submit = find.widgetWithText(FilledButton, 'CONTINUE');
    expect(tester.widget<FilledButton>(submit).onPressed, isNull);
    expect(
      tester.widget<AuthProgress>(find.byType(AuthProgress)).birthDateSelected,
      isFalse,
    );

    final wheels = find.byType(CupertinoPicker);
    final picker = find.byType(CupertinoDatePicker);
    final select = find.widgetWithText(FilledButton, 'SELECT');
    final close = find.byTooltip('Close');
    for (final label in ['Month', 'Day', 'Year']) {
      await tester.tap(find.text(label));
      await tester.pumpAndSettle();
      expect(find.text('Select your Birthday'), findsOneWidget);
      expect(wheels, findsNWidgets(3));
      expect(tester.testTextInput.isVisible, isFalse);
      await tester.tap(close);
      await tester.pumpAndSettle();
      expect(picker, findsNothing);
      expect(container.read(authViewModelProvider).birthDate, isNull);
    }

    await tester.tap(find.text('Year'));
    await tester.pumpAndSettle();
    final initial = tester.widget<CupertinoDatePicker>(picker).initialDateTime;
    final today = tester.widget<CupertinoDatePicker>(picker).maximumDate!;
    tester
        .widget<CupertinoPicker>(wheels.last)
        .scrollController!
        .jumpToItem(today.year);
    await tester.pumpAndSettle();
    await tester.tap(select);
    await tester.pumpAndSettle();
    expect(
      find.text('Enter a valid date; you must be at least 13.'),
      findsOneWidget,
    );
    expect(tester.widget<FilledButton>(submit).onPressed, isNull);

    await tester.tap(find.text('${today.year}'));
    await tester.pumpAndSettle();
    final underage = container.read(authViewModelProvider).birthDate!;
    expect(
      tester.widget<CupertinoDatePicker>(picker).initialDateTime,
      underage,
    );
    tester
        .widget<CupertinoPicker>(wheels.last)
        .scrollController!
        .jumpToItem(initial.year);
    await tester.pumpAndSettle();
    await tester.tap(close);
    await tester.pumpAndSettle();
    expect(container.read(authViewModelProvider).birthDate, underage);

    await tester.tap(find.text('${today.year}'));
    await tester.pumpAndSettle();
    tester
        .widget<CupertinoPicker>(wheels.last)
        .scrollController!
        .jumpToItem(initial.year);
    await tester.pumpAndSettle();
    final day = initial.day > 1 ? initial.day - 1 : 2;
    await tester.tap(
      find
          .descendant(of: wheels.first, matching: find.text('$day'))
          .hitTestable(),
    );
    await tester.pumpAndSettle();
    await tester.tap(select);
    await tester.pumpAndSettle();
    final selected = DateTime(initial.year, initial.month, day);
    expect(container.read(authViewModelProvider).birthDate, selected);
    expect(
      tester.widget<AuthProgress>(find.byType(AuthProgress)).birthDateSelected,
      isTrue,
    );
    expect(find.text('${selected.year}'), findsOneWidget);
    expect(find.text('${selected.day}'), findsOneWidget);
    expect(
      find.text('Enter a valid date; you must be at least 13.'),
      findsNothing,
    );
    expect(repository.registrations, 0);
    await tester.ensureVisible(submit);
    await tester.tap(submit);
    await tester.tap(submit);
    await tester.pump();
    expect(repository.registrations, 1);
    expect(container.read(authViewModelProvider).loading, isTrue);
    await tester.pump(const Duration(seconds: 2));
    await tester.pump();
    expect(router.routeInformationProvider.value.uri.path, '/welcome');
    expect(router.canPop(), isFalse);
    await tester.binding.handlePopRoute();
    await tester.pump();
    expect(find.byType(AuthScreen, skipOffstage: false), findsNothing);
    expect(find.text('Welcome to the world of J’donuts'), findsOneWidget);
    expect(
      tester.widget<DonutArtwork>(find.byType(DonutArtwork)).scrollColumns,
      isTrue,
    );
    expect(container.read(authViewModelProvider).member!.birthDate, selected);
    expect(store.saved, isNull);
    await tester.ensureVisible(find.text('LET’S EXPLORE'));
    await tester.tap(find.text('LET’S EXPLORE'));
    await tester.idle();
    expect(store.saved, 'member-1');
    await tester.pumpWidget(const SizedBox());
  });
  testWidgets(
    'Onboarding floats donuts before the phone form on a small screen',
    (tester) async {
      tester.view.physicalSize = const Size(320, 568);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(
        tester.platformDispatcher.clearAccessibilityFeaturesTestValue,
      );
      await tester.pumpWidget(
        ProviderScope(
          overrides: [authRepositoryProvider.overrideWithValue(StubAuth())],
          child: MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            builder: (context, child) => MediaQuery(
              data: MediaQuery.of(
                context,
              ).copyWith(textScaler: const TextScaler.linear(1.3)),
              child: child!,
            ),
            home: const AuthScreen(),
          ),
        ),
      );
      await tester.pump(const Duration(seconds: 2));
      final artwork = find.byType(DonutArtwork);
      expect(tester.getTopLeft(artwork), Offset.zero);
      final donuts = find.descendant(of: artwork, matching: find.byType(Image));
      expect(donuts, findsNWidgets(4));
      List<Offset> positions() => [
        for (var index = 0; index < 4; index++)
          tester.getCenter(donuts.at(index)),
      ];
      final start = positions();
      await tester.pump(const Duration(seconds: 1));
      final moved = positions();
      for (var index = 0; index < 4; index++) {
        expect((moved[index] - start[index]).distance, inExclusiveRange(0, 12));
      }
      expect(moved[0].dy, lessThan(start[0].dy));
      expect(moved[1].dy, greaterThan(start[1].dy));

      tester.platformDispatcher.accessibilityFeaturesTestValue =
          const FakeAccessibilityFeatures(disableAnimations: true);
      await tester.pumpAndSettle();
      final paused = positions();
      await tester.pump(const Duration(seconds: 5));
      expect(positions(), paused);
      expect(tester.takeException(), isNull);
      await tester.ensureVisible(find.text('LET’S GET STARTED'));
      await tester.tap(find.text('LET’S GET STARTED'));
      await tester.pumpAndSettle();
      expect(find.text('Enter your phone number'), findsOneWidget);
      expect(artwork, findsNothing);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
    },
  );
}
