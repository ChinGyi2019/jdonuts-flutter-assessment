import 'dart:async';

import 'package:code_test_madivizion/app/active_member.dart';
import 'package:code_test_madivizion/app/app.dart';
import 'package:code_test_madivizion/app/session.dart';
import 'package:code_test_madivizion/core/connectivity/connectivity_monitor.dart';
import 'package:code_test_madivizion/core/connectivity/connectivity_providers.dart';
import 'package:code_test_madivizion/core/error/failure.dart';
import 'package:code_test_madivizion/core/media/catalog_image.dart';
import 'package:code_test_madivizion/core/media/image_reference.dart';
import 'package:code_test_madivizion/core/member/domain/member.dart';
import 'package:code_test_madivizion/core/storage/app_database.dart';
import 'package:code_test_madivizion/core/storage/catalog_refresh.dart';
import 'package:code_test_madivizion/core/storage/catalog_refresh_providers.dart';
import 'package:code_test_madivizion/core/storage/catalog_seeder.dart';
import 'package:code_test_madivizion/core/theme/app_motion.dart';
import 'package:code_test_madivizion/core/theme/app_theme.dart';
import 'package:code_test_madivizion/core/widgets/skeleton.dart';
import 'package:code_test_madivizion/features/auth/di/auth_providers.dart';
import 'package:code_test_madivizion/features/home/di/home_providers.dart';
import 'package:code_test_madivizion/features/home/domain/entities/home_catalog.dart';
import 'package:code_test_madivizion/features/product/di/product_providers.dart';
import 'package:code_test_madivizion/features/product/domain/entities/product.dart';
import 'package:code_test_madivizion/features/rewards/di/rewards_providers.dart';
import 'package:code_test_madivizion/features/rewards/domain/entities/reward_tier.dart';
import 'package:code_test_madivizion/features/rewards/presentation/widgets/reward_points_ring.dart';
import 'package:code_test_madivizion/features/settings/presentation/views/settings_screen.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../app/router_test.dart' show FakeSessionStore;
import '../auth/auth_viewmodel_test.dart' show StubAuth;

const _image = ImageReference(asset: 'assets/images/coconut-donut.webp');
const _member = Member(
  id: 'member_demo',
  firstName: 'Hania',
  points: 680000,
  notificationCount: 2,
  rewardsBadgeCount: 3,
  image: _image,
);
const _product = Product(
  id: 'p_coconut',
  code: 'JD022123',
  name: 'Coconut Donut',
  priceMmk: 3200,
  description: 'Chocolate with shredded coconut.',
  isNew: true,
  discountPercent: 20,
  image: _image,
);

const _firstOffer = HomeBanner(
  id: 'central',
  title: 'We are now at Central Boulevard',
  badge: 'New shop',
  position: 0,
  image: _image,
);

void main() {
  for (final scale in [1.0, 1.3]) {
    testWidgets('shop description fits two lines at text scale $scale', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(320, 568);
      tester.view.devicePixelRatio = 1;
      tester.platformDispatcher.textScaleFactorTestValue = scale;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
      const address = 'First line of address\nSecond line of address';
      await tester.pumpWidget(_app(shopAddress: address));
      await tester.pumpAndSettle();
      await tester.scrollUntilVisible(
          find.text('There are 4 J’Donut shops near you. 😊'),
        450,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();
      final description = find.text(address).first;
      final paragraph = tester.renderObject<RenderParagraph>(
        find.descendant(of: description, matching: find.byType(RichText)).first,
      );
      final boxes = paragraph.getBoxesForSelection(
        const TextSelection(baseOffset: 0, extentOffset: address.length),
      );
      expect(boxes.length, 2);
      expect(boxes.last.bottom, lessThanOrEqualTo(paragraph.size.height));
      expect(
        tester.getBottomLeft(description).dy + 8,
        lessThanOrEqualTo(
          tester.getTopLeft(find.text('Order Online').first).dy + .01,
        ),
      );
      expect(tester.takeException(), isNull);
    });
  }

  for (final size in [const Size(320, 568), const Size(1024, 768)]) {
    testWidgets('navigation and screens fit at $size', (tester) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1;
      tester.view.padding = const FakeViewPadding(bottom: 34);
      tester.platformDispatcher.accessibilityFeaturesTestValue =
          const FakeAccessibilityFeatures(disableAnimations: true);
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.view.resetPadding);
      addTearDown(
        tester.platformDispatcher.clearAccessibilityFeaturesTestValue,
      );
      await tester.pumpWidget(_app());
      await tester.pumpAndSettle();
      await tester.pump(const Duration(milliseconds: 400));
      await tester.pumpAndSettle();

      expect(find.text('Hania'), findsOneWidget);
      await tester.tap(find.byIcon(LucideIcons.crown));
      await tester.pumpAndSettle();
      final ring = tester.getRect(find.byType(RewardPointsRing));
      expect(ring.left, greaterThanOrEqualTo(0));
      expect(ring.right, lessThanOrEqualTo(size.width));
      expect(find.text('J’ Donuts Rewards'), findsOneWidget);

      await tester.tap(find.byIcon(LucideIcons.settings));
      await tester.pumpAndSettle();
      expect(find.byType(SettingsScreen), findsOneWidget);
      final logout = find.text('Log out');
      await tester.scrollUntilVisible(
        logout,
        120,
        scrollable: find
            .descendant(
              of: find.byType(SettingsScreen),
              matching: find.byType(Scrollable),
            )
            .first,
      );
      await tester.pumpAndSettle();
      expect(logout.hitTestable(), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets(
    'shows Home shimmer after OTP login and respects reduced motion',
    (tester) async {
      addTearDown(
        tester.platformDispatcher.clearAccessibilityFeaturesTestValue,
      );
      await tester.pumpWidget(_app(signedIn: false));
      await tester.pump();
      await tester.pump(const Duration(seconds: 2));
      await tester.tap(find.text('Log In'));
      await tester.pumpAndSettle();
      final submit = find.widgetWithText(FilledButton, 'CONTINUE');
      await tester.enterText(find.byType(TextField), '09254135592');
      await tester.pump();
      await tester.tap(submit);
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(const ValueKey('otp-input')), '123456');
      await tester.pump();
      await tester.tap(submit);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      final shimmer = find.byType(SkeletonShimmer);
      final mask = find.descendant(
        of: shimmer,
        matching: find.byType(ShaderMask),
      );
      expect(shimmer, findsWidgets);
      expect(mask, findsWidgets);
      expect(find.text('Hania'), findsNothing);
      tester.platformDispatcher.accessibilityFeaturesTestValue =
          const FakeAccessibilityFeatures(disableAnimations: true);
      await tester.pump();
      expect(shimmer, findsWidgets);
      expect(mask, findsNothing);

      await tester.pumpAndSettle();
      expect(shimmer, findsNothing);
      expect(find.text('Hania'), findsOneWidget);
    },
  );

  testWidgets('pull to refresh shimmers until refresh finishes', (
    tester,
  ) async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    final seed = Completer<String>();
    await tester.pumpWidget(
      _app(
        refresh: CatalogRefresh(
          seeder: CatalogSeeder(database, () => seed.future),
          isOnline: () => false,
          refreshImages: () async => right(unit),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Hania'), findsOneWidget);
    final feed = find.byKey(const PageStorageKey('home-feed'));
    await tester.drag(feed, const Offset(0, 420));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));
    await tester.pump(const Duration(seconds: 1));
    expect(find.byType(SkeletonShimmer), findsWidgets);
    expect(find.byType(RefreshProgressIndicator), findsOneWidget);
    expect(find.text('Hania'), findsNothing);

    seed.completeError(StateError('Catalog unavailable'));
    await tester.pumpAndSettle();
    expect(find.byType(SkeletonShimmer), findsNothing);
    expect(find.text('Hania'), findsOneWidget);
    expect(find.byType(SnackBar), findsOneWidget);
  });

  testWidgets('slides the bottom selection and keeps the last shop above it', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 568);
    tester.view.devicePixelRatio = 1;
    tester.view.padding = const FakeViewPadding(bottom: 34);
    tester.platformDispatcher.textScaleFactorTestValue = 1.3;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPadding);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();

    final pill = find.byWidgetPredicate((widget) {
      final decoration = widget is DecoratedBox ? widget.decoration : null;
      return decoration is ShapeDecoration &&
          decoration.color == AppColors.catalogPink &&
          decoration.shape is StadiumBorder;
    });
    final homeX = tester.getCenter(pill).dx;
    await tester.tap(find.byIcon(LucideIcons.crown));
    await tester.pump();
    await tester.pump(AppMotion.standard ~/ 2);
    final midpoint = tester.getCenter(pill).dx;
    await tester.pumpAndSettle();
    expect(midpoint, greaterThan(homeX));
    expect(tester.getCenter(pill).dx, greaterThan(midpoint));
    expect(find.text('J’ Donuts Rewards'), findsOneWidget);

    await tester.tap(find.byIcon(LucideIcons.house));
    await tester.pumpAndSettle();
    expect(tester.getCenter(pill).dx, homeX);
    final feed = find.byKey(const PageStorageKey('home-feed'));
    final scrollable = find
        .descendant(of: feed, matching: find.byType(Scrollable))
        .first;
    final position = tester.state<ScrollableState>(scrollable).position;
    expect(position.axisDirection, AxisDirection.down);
    // The lazy list updates its estimated extent as the shop cards mount.
    for (var attempt = 0; attempt < 3 && position.extentAfter > 0; attempt++) {
      position.jumpTo(position.maxScrollExtent);
      await tester.pumpAndSettle();
    }
    final order = find.text('Order Online').hitTestable();
    expect(order, findsWidgets);
    expect(
      tester.getBottomLeft(order.first).dy,
      lessThan(tester.getTopLeft(pill).dy),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('renders the cached feed and opens product with matching Hero', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();

    expect(find.text('Hania'), findsOneWidget);
    expect(find.text('Silver member'), findsOneWidget);
    expect(find.text('500 points left to become Gold Member'), findsOneWidget);
    expect(find.bySemanticsLabel('2 notifications'), findsOneWidget);
    semantics.dispose();
    expect(find.text('You’re offline'), findsOneWidget);
    expect(find.text('20% off'), findsWidgets);

    final card = find.text('Coconut Donut').hitTestable().first;
    final source = tester.widget<Hero>(find.byType(Hero).first);
    await tester.tap(card);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 120));
    final flight = find.byWidgetPredicate(
      (widget) => widget is Hero && widget.tag == source.tag,
    );
    expect(flight, findsWidgets);
    expect(
      find.descendant(of: flight, matching: find.byType(CatalogImage)),
      findsNothing,
    );
    await tester.pumpAndSettle();
    expect(find.text('JD022123'), findsOneWidget);
    expect(find.text('New'), findsOneWidget);
    expect(find.text('3,200 MMK'), findsNWidgets(2));
    expect(
      tester
          .widget<IconButton>(
            find.byWidgetPredicate(
              (widget) =>
                  widget is IconButton && widget.tooltip == 'Decrease quantity',
            ),
          )
          .onPressed,
      isNull,
    );

    await tester.tap(find.byTooltip('Increase quantity'));
    await tester.pumpAndSettle();
    expect(find.text('6,400 MMK'), findsOneWidget);
    await tester.tap(find.byTooltip('Decrease quantity'));
    await tester.pumpAndSettle();
    expect(find.text('6,400 MMK'), findsNothing);
    await tester.tap(find.text('ADD TO CART'));
    await tester.pumpAndSettle();
    expect(find.text('Added to cart'), findsOneWidget);

    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('There are 4 J’Donut shops near you. 😊'),
      450,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('EXPLORE NOW'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('autoplays banners and pauses with Reduce Motion', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 568);
    tester.view.devicePixelRatio = 1;
    tester.platformDispatcher.textScaleFactorTestValue = 1.3;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    addTearDown(tester.platformDispatcher.clearAccessibilityFeaturesTestValue);

    await tester.pumpWidget(
      _app(
        banners: const [
          _firstOffer,
          HomeBanner(
            id: 'seasonal',
            title: 'Share a box of seasonal specials',
            badge: '50% off',
            position: 1,
            image: _image,
          ),
        ],
      ),
    );
    await tester.pumpAndSettle();
    final pages = tester.widget<PageView>(find.byType(PageView)).controller!;
    expect(pages.page, 0);

    await tester.pump(AppMotion.bannerInterval);
    await tester.pumpAndSettle();
    expect(pages.page, closeTo(1, .001));

    tester.platformDispatcher.accessibilityFeaturesTestValue =
        const FakeAccessibilityFeatures(disableAnimations: true);
    await tester.pumpAndSettle();
    await tester.pump(AppMotion.bannerInterval * 2);
    expect(pages.page, closeTo(1, .001));
    expect(tester.takeException(), isNull);
  });

  testWidgets('shows independent loading, empty, and error states on Home', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 1040);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final pending = StreamController<Either<Failure, List<Product>>>();
    addTearDown(pending.close);
    await tester.pumpWidget(_app(pending: pending.stream));
    await tester.pump();
    await tester.pump(const Duration(seconds: 2));

    expect(find.text('No offers right now.'), findsOneWidget);
    expect(find.text('Could not load this section.'), findsOneWidget);
    expect(find.text('No products in this section yet.'), findsOneWidget);
    await tester.pump();
    expect(find.byType(SkeletonShimmer), findsOneWidget);
    expect(find.text('Try again'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('clicking profile in HomeHeader navigates to SettingsScreen', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();

    expect(find.text('Hania'), findsOneWidget);
    await tester.tap(find.text('Hania'));
    await tester.pumpAndSettle();

    expect(find.byType(SettingsScreen), findsOneWidget);
  });
}

Widget _app({
  Stream<Either<Failure, List<Product>>>? pending,
  List<HomeBanner> banners = const [_firstOffer],
  bool signedIn = true,
  CatalogRefresh? refresh,
  String shopAddress = 'Yangon',
}) => ProviderScope(
  overrides: [
    sessionStoreProvider.overrideWithValue(
      FakeSessionStore(Future.value(signedIn ? _member.id : null)),
    ),
    if (!signedIn) authRepositoryProvider.overrideWithValue(_LoginAuth()),
    if (refresh != null) catalogRefreshProvider.overrideWithValue(refresh),
    networkStatusProvider.overrideWith(
      (_) => Stream.value(NetworkStatus.offline),
    ),
    activeMemberProvider.overrideWith((_) => Stream.value(right(_member))),
    rewardChallengesProvider.overrideWith((_) => Stream.value(right([]))),
    rewardTiersProvider.overrideWith(
      (_) => Stream.value(
        right(const [
          RewardTier(id: 'silver', name: 'Silver', minimumPoints: 678500),
          RewardTier(id: 'gold', name: 'Gold', minimumPoints: 680500),
        ]),
      ),
    ),
    homeBannersProvider.overrideWith(
      (_) => Stream.value(right(pending == null ? banners : [])),
    ),
    homeSectionProvider.overrideWith((_, section) {
      if (pending == null) return Stream.value(right(const [_product]));
      return switch (section) {
        HomeSection.seasonalSpecials => Stream.value(
          left(const StorageFailure('Failed')),
        ),
        HomeSection.popular => Stream.value(right([])),
        HomeSection.orderAgain => pending,
      };
    }),
    homeShopsProvider.overrideWith(
      (_) => Stream.value(
        right(
          List.generate(
            4,
            (index) => Shop(
              id: 'shop-$index',
              name: 'Shop ${index + 1}',
              address: shopAddress,
              position: index,
              image: _image,
            ),
          ),
        ),
      ),
    ),
    productByIdProvider(
      'p_coconut',
    ).overrideWith((_) => Stream.value(right(_product))),
  ],
  child: const MainApp(),
);

class _LoginAuth extends StubAuth {
  @override
  Future<Either<Failure, Member?>> findMember(String phone) async =>
      right(_member);
}
