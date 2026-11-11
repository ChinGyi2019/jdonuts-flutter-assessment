import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/theme/app_motion.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/press_scale.dart';
import '../../../../l10n/app_localizations.dart';
import '../viewmodels/rewards_viewmodel.dart';
import 'reward_points_ring.dart';
import 'reward_tier_ladder.dart';

class RewardsHeader extends StatelessWidget {
  const RewardsHeader({
    required this.data,
    required this.animation,
    required this.onReplay,
    super.key,
  });

  final RewardsState data;
  final Animation<double> animation;
  final VoidCallback onReplay;

  @override
  Widget build(BuildContext context) => ColoredBox(
    color: Colors.white,
    child: Column(
      children: [
        const SizedBox(height: 12),
        RewardsHeading(
          badgeCount: data.badgeCount,
          animation: animation,
          onReplay: onReplay,
        ),
        const SizedBox(height: 35),
        LayoutBuilder(builder: (_, box) => _summary(box.maxWidth)),
        const SizedBox(height: 36),
      ],
    ),
  );

  Widget _summary(double width) {
    if (width == 0) return const SizedBox.shrink();
    final gutter = (width * .05).clamp(16.0, 32.0);
    final ring = math.min((width - 2 * gutter) * .43, 240.0);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: gutter),
      child: IntrinsicHeight(
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: ring),
          child: Row(
            children: [
              Expanded(
                child: RewardTierLadder(
                  tiers: data.tiers,
                  progress: data.progress,
                  animation: animation,
                ),
              ),
              const SizedBox(width: 12),
              Center(child: _ring(ring)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _ring(double size) => SizedBox.square(
    dimension: size,
    child: RewardPointsRing(
      progress: data.progress,
      animation: animation.drive(
        CurveTween(
          curve: const Interval(0, .80, curve: AppMotion.rewardsCountCurve),
        ),
      ),
    ),
  );
}

class RewardsHeading extends StatelessWidget {
  const RewardsHeading({
    this.badgeCount,
    this.animation,
    this.onReplay,
    super.key,
  });

  final int? badgeCount;
  final Animation<double>? animation;
  final VoidCallback? onReplay;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(
        child: Padding(
          padding: const EdgeInsetsDirectional.only(start: 25, end: 6),
          child: Semantics(
            header: true,
            child: Text(
              AppLocalizations.of(context)!.rewardsTitle,
              style: const TextStyle(
                fontSize: 21,
                height: 1.2,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
      if (badgeCount != null) _badge(context, badgeCount!),
    ],
  );

  Widget _badge(BuildContext context, int count) {
    final strings = AppLocalizations.of(context)!;
    final reveal = animation!.drive(
      CurveTween(curve: const Interval(.24, .62)),
    );
    return FadeTransition(
      opacity: reveal.drive(CurveTween(curve: AppMotion.entranceFade)),
      child: ScaleTransition(
        alignment: Alignment.centerRight,
        scale: reveal.drive(CurveTween(curve: AppMotion.rewardsPopCurve)),
        child: _badgeButton(strings, count),
      ),
    );
  }

  Widget _badgeButton(AppLocalizations strings, int count) => PressScale(
    child: TextButton(
      onPressed: onReplay,
      style: TextButton.styleFrom(
        padding: const EdgeInsetsDirectional.fromSTEB(16, 7, 8, 7),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.horizontal(left: Radius.circular(22)),
        ),
        foregroundColor: Colors.white,
        backgroundColor: AppColors.catalogOrange,
        minimumSize: const Size(0, 38),
        textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
      ),
      child: Tooltip(
        message: strings.replayRewards,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(strings.rewardsBadge),
            if (count > 0) ...[const SizedBox(width: 4), _badgeNumber(count)],
          ],
        ),
      ),
    ),
  );

  Widget _badgeNumber(int count) => Container(
    constraints: const BoxConstraints(minWidth: 17, minHeight: 17),
    padding: const EdgeInsets.symmetric(horizontal: 3),
    alignment: Alignment.center,
    decoration: const ShapeDecoration(
      color: Colors.white,
      shape: StadiumBorder(),
    ),
    child: Text(
      '$count',
      style: const TextStyle(
        fontSize: 11,
        height: 1,
        color: AppColors.catalogText,
      ),
    ),
  );
}
