import 'dart:async';

import 'package:code_test_madivizion/app/active_member.dart';
import 'package:code_test_madivizion/core/error/failure.dart';
import 'package:code_test_madivizion/core/media/image_reference.dart';
import 'package:code_test_madivizion/core/member/domain/member.dart';
import 'package:code_test_madivizion/core/theme/app_theme.dart';
import 'package:code_test_madivizion/features/rewards/di/rewards_providers.dart';
import 'package:code_test_madivizion/features/rewards/domain/entities/reward_challenge.dart';
import 'package:code_test_madivizion/features/rewards/domain/entities/reward_tier.dart';
import 'package:code_test_madivizion/features/rewards/presentation/views/rewards_screen.dart';
import 'package:code_test_madivizion/features/rewards/presentation/widgets/reward_challenge_art.dart';
import 'package:code_test_madivizion/features/rewards/presentation/widgets/reward_points_ring.dart';
import 'package:code_test_madivizion/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';

void main() {
  testWidgets('counts up on entry, replays, and switches challenge tabs', (
    tester,
  ) async {
    final active = ValueNotifier(true);
    addTearDown(active.dispose);
    await _mount(tester, active: active);
    await _pumpUntilSummary(tester);
    expect(find.text('0'), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 300));
    final ring = tester.widget<RewardPointsRing>(find.byType(RewardPointsRing));
    expect(ring.animation.value, inExclusiveRange(0, 1));
    expect(find.text('680,000'), findsNothing);

    await tester.pumpAndSettle();
    expect(find.text('680,000'), findsOneWidget);
    expect(find.text('500 pts Remaining\nto become Gold'), findsOneWidget);
    expect(find.text('3'), findsOneWidget);

    await tester.tap(find.text('Rewards'));
    await tester.pump();
    expect(find.text('0'), findsOneWidget);
    await tester.pumpAndSettle();
    expect(find.text('680,000'), findsOneWidget);

    await tester.tap(find.text('Gift'));
    await tester.pumpAndSettle();
    expect(find.text('No gifts yet'), findsOneWidget);
    expect(find.text('EARN'), findsNothing);
    await tester.tap(find.text('Eat more earn more'));
    await tester.pumpAndSettle();
    expect(find.text('No gifts yet'), findsNothing);
    expect(find.text('4/4'), findsOneWidget);

    active.value = false;
    await tester.pump();
    active.value = true;
    await tester.pump();
    expect(find.text('0'), findsOneWidget);
    await tester.pumpAndSettle();
    expect(find.text('680,000'), findsOneWidget);
  });

  testWidgets(
    'shows final progress and correct Earn states with Reduce Motion',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(320, 568));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await _mount(tester, reduceMotion: true, textScale: 1.3);
      await _pumpUntilSummary(tester);
      final ring = tester.widget<RewardPointsRing>(
        find.byType(RewardPointsRing),
      );
      expect(ring.animation.value, 1);
      expect(find.text('680,000'), findsOneWidget);
      expect(find.text('Silver'), findsOneWidget);
      expect(find.text('Platinum'), findsOneWidget);
      final list = find.byType(Scrollable);
      final firstEarn = find.widgetWithText(TextButton, 'EARN').first;
      await tester.drag(list, const Offset(0, -280));
      await tester.pumpAndSettle();
      expect(tester.widget<TextButton>(firstEarn).onPressed, isNotNull);
      await tester.tap(firstEarn);
      await tester.pump();
      expect(find.text('4/4'), findsOneWidget);

      final coffee = find.text('9/12');
      await tester.scrollUntilVisible(coffee, 120, scrollable: list);
      expect(coffee, findsOneWidget);
      final earnButtons = tester.widgetList<TextButton>(
        find.widgetWithText(TextButton, 'EARN'),
      );
      expect(
        earnButtons.where((button) => button.onPressed == null),
        hasLength(2),
      );
      expect(
        tester
            .widgetList<RewardChallengeArt>(find.byType(RewardChallengeArt))
            .every((art) => art.entrance.value == 1),
        isTrue,
      );
    },
  );

  testWidgets('replays individual donut progress and scales the Earn button', (
    tester,
  ) async {
    await _mount(tester);
    await _pumpUntilSummary(tester);
    await tester.pumpAndSettle();
    await tester.drag(find.byType(Scrollable), const Offset(0, -290));
    await tester.pumpAndSettle();

    final donut = find.byType(RewardChallengeArt).first;
    final reveal = find.descendant(of: donut, matching: find.byType(ClipPath));
    final size = tester.getSize(reveal);
    final sample = Offset(size.width * .75, size.height * .25);
    Path clip() => tester.widget<ClipPath>(reveal).clipper!.getClip(size);
    expect(clip().contains(sample), isTrue);
    await tester.tap(donut);
    await tester.pump();
    expect(clip().contains(sample), isFalse);
    await tester.pumpAndSettle();
    expect(clip().contains(sample), isTrue);

    final earn = find.widgetWithText(TextButton, 'EARN').first;
    final gesture = await tester.startGesture(tester.getCenter(earn));
    await tester.pump();
    final press = find.ancestor(of: earn, matching: find.byType(AnimatedScale));
    expect(tester.widget<AnimatedScale>(press).scale, .96);
    await gesture.up();
    await tester.pumpAndSettle();
    expect(tester.widget<AnimatedScale>(press).scale, 1);
    expect(find.text('4/4'), findsOneWidget);
  });

  testWidgets(
    'shows loading, retries a challenge failure, and handles an empty list',
    (tester) async {
      final result = Completer<Either<Failure, List<RewardChallenge>>>();
      var attempts = 0;
      await _mount(
        tester,
        reduceMotion: true,
        challenges: () => attempts++ == 0
            ? Stream.fromFuture(result.future)
            : Stream.value(right([])),
      );
      await tester.pump();
      expect(find.text('Loading rewards'), findsOneWidget);
      result.complete(left(const StorageFailure('Unavailable')));
      await tester.pumpAndSettle();
      expect(find.text('Could not load rewards.'), findsOneWidget);
      await tester.tap(find.text('Try again'));
      await tester.pumpAndSettle();
      expect(find.text('No challenges right now.'), findsOneWidget);
    },
  );
}

Future<void> _pumpUntilSummary(WidgetTester tester) async {
  final summary = find.byType(RewardPointsRing);
  for (var frame = 0; frame < 12 && summary.evaluate().isEmpty; frame++) {
    await tester.pump();
  }
  expect(summary, findsOneWidget);
}

Future<void> _mount(
  WidgetTester tester, {
  bool reduceMotion = false,
  double textScale = 1,
  ValueNotifier<bool>? active,
  Stream<Either<Failure, List<RewardChallenge>>> Function()? challenges,
}) => tester.pumpWidget(
  ProviderScope(
    overrides: [
      activeMemberProvider.overrideWith((_) => Stream.value(right(_member))),
      rewardTiersProvider.overrideWith((_) => Stream.value(right(_tiers))),
      rewardChallengesProvider.overrideWith(
        (_) => challenges?.call() ?? Stream.value(right(_challenges)),
      ),
    ],
    child: MaterialApp(
      theme: AppTheme.light,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(
          disableAnimations: reduceMotion,
          textScaler: TextScaler.linear(textScale),
        ),
        child: child!,
      ),
      home: Scaffold(
        body: active == null
            ? const RewardsScreen()
            : ValueListenableBuilder(
                valueListenable: active,
                builder: (_, enabled, child) =>
                    TickerMode(enabled: enabled, child: child!),
                child: const RewardsScreen(),
              ),
      ),
    ),
  ),
);

const _member = Member(
  id: 'member',
  firstName: 'Sam',
  points: 680000,
  notificationCount: 0,
  rewardsBadgeCount: 3,
  image: ImageReference(asset: 'assets/images/member-avatar.webp'),
);

const _tiers = [
  RewardTier(id: 'silver', name: 'Silver', minimumPoints: 678500),
  RewardTier(id: 'gold', name: 'Gold', minimumPoints: 680500),
  RewardTier(id: 'platinum', name: 'Platinum', minimumPoints: 750000),
];

const _challenges = [
  RewardChallenge(
    id: 'done',
    title: 'Eat 4 Coco donuts',
    artwork: ChallengeArtwork.donut,
    completedQuantity: 4,
    targetQuantity: 4,
    rewardPoints: 100,
    position: 0,
    image: ImageReference(asset: 'assets/images/reward-donut.webp'),
  ),
  RewardChallenge(
    id: 'next',
    title: 'Eat 4 Coco donuts',
    artwork: ChallengeArtwork.donut,
    completedQuantity: 1,
    targetQuantity: 4,
    rewardPoints: 100,
    position: 1,
    image: ImageReference(asset: 'assets/images/reward-donut.webp'),
  ),
  RewardChallenge(
    id: 'coffee',
    title: 'Drink 12 cups americano',
    artwork: ChallengeArtwork.coffee,
    completedQuantity: 9,
    targetQuantity: 12,
    rewardPoints: 100,
    position: 2,
    image: ImageReference(asset: 'assets/images/reward-coffee.webp'),
  ),
];
