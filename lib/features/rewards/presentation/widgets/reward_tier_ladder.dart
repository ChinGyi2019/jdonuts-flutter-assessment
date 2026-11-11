import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/theme/app_motion.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/reward_tier.dart';

class RewardTierLadder extends StatelessWidget {
  const RewardTierLadder({
    required this.tiers,
    required this.progress,
    required this.animation,
    super.key,
  });

  final List<RewardTier> tiers;
  final TierProgress progress;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      for (final (index, tier) in tiers.indexed) ...[
        _tier(context, tier, index),
        if (index < tiers.length - 1)
          Expanded(child: _connector(tier, tiers[index + 1], index)),
      ],
    ],
  );

  Widget _tier(BuildContext context, RewardTier tier, int index) {
    final current = tier.id == progress.current?.id;
    final start = _start(index);
    final entrance = animation.drive(
      CurveTween(
        curve: Interval(start, start + .22, curve: AppMotion.entranceFade),
      ),
    );
    return FadeTransition(
      opacity: entrance,
      child: SlideTransition(
        position: entrance.drive(
          Tween(begin: const Offset(-.07, 0), end: Offset.zero),
        ),
        child: _TierRow(
          tier: tier,
          label: _label(context, tier, current),
          current: current,
          index: index,
        ),
      ),
    );
  }

  double _start(int index) =>
      .10 + .15 * index / (tiers.length > 3 ? tiers.length / 3 : 1);

  Widget _connector(RewardTier tier, RewardTier next, int index) {
    final current = tier.id == progress.current?.id;
    final reached = next.minimumPoints <= progress.points;
    final fraction = reached ? 1.0 : (current ? progress.fraction : 0.0);
    final start = _start(index + 1);
    final fill = animation.drive(
      CurveTween(
        curve: Interval(
          start + .10,
          start + .45,
          curve: AppMotion.entranceFade,
        ),
      ),
    );
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 1, bottom: 1),
      child: Align(
        alignment: Alignment.centerLeft,
        child: FadeTransition(
          opacity: fill,
          child: SizedBox(
            width: 2,
            child: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 18),
              child: Stack(
                children: [
                  const Positioned.fill(
                    child: ColoredBox(color: AppColors.catalogBackground),
                  ),
                  Positioned.fill(
                    child: AnimatedBuilder(
                      animation: fill,
                      builder: (_, _) => FractionallySizedBox(
                        alignment: Alignment.topCenter,
                        heightFactor: fill.value * fraction,
                        child: const ColoredBox(color: Color(0xFF777777)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _label(BuildContext context, RewardTier tier, bool current) {
    final strings = AppLocalizations.of(context)!;
    if (current) return strings.currentRewardTier;
    if (tier.id == progress.next?.id) {
      return strings.nextRewardTier(progress.pointsRemaining!, tier.name);
    }
    return tier.minimumPoints <= progress.points
        ? ''
        : strings.upcomingRewardTier;
  }
}

class _TierRow extends StatelessWidget {
  const _TierRow({
    required this.tier,
    required this.label,
    required this.current,
    required this.index,
  });

  final RewardTier tier;
  final String label;
  final bool current;
  final int index;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      SizedBox(
        width: 34,
        child: Center(
          child: _TierMedal(tier: tier, index: index, current: current),
        ),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              tier.name,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.rewardsText,
              ),
            ),
            if (label.isNotEmpty)
              Text(
                label,
                style: const TextStyle(
                  fontSize: 9.5,
                  height: 1.24,
                  color: AppColors.rewardsText,
                ),
              ),
          ],
        ),
      ),
    ],
  );
}

class _TierMedal extends StatelessWidget {
  const _TierMedal({
    required this.tier,
    required this.index,
    required this.current,
  });

  final RewardTier tier;
  final int index;
  final bool current;

  @override
  Widget build(BuildContext context) {
    final size = current ? 34.0 : 27.0;
    final (light, dark, ink) = switch (tier.id) {
      'gold' => (
        const Color(0xFFFFF2BC),
        const Color(0xFFE9BE46),
        const Color(0xFFA99D68),
      ),
      'platinum' => (
        const Color(0xFFD4F1F6),
        AppColors.catalogBlue,
        const Color(0xFF8FA7AF),
      ),
      _ => (
        const Color(0xFFDFE1E1),
        const Color(0xFFACAEAE),
        const Color(0xFF858888),
      ),
    };
    return ExcludeSemantics(
      child: SizedBox(
        width: size,
        height: size * 1.17,
        child: CustomPaint(
          painter: _MedalPainter(light, dark),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  (index + 1).clamp(1, 3),
                  (_) => Icon(
                    LucideIcons.star,
                    color: ink,
                    size: current ? 8 : 6,
                    fill: 1,
                  ),
                ),
              ),
              Text(
                tier.name.isEmpty
                    ? ''
                    : tier.name.characters.first.toUpperCase(),
                style: TextStyle(
                  color: ink,
                  fontSize: current ? 14 : 11,
                  height: 1.16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MedalPainter extends CustomPainter {
  const _MedalPainter(this.light, this.dark);

  final Color light;
  final Color dark;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final shield = Path()
      ..moveTo(w * .38, h * .06)
      ..quadraticBezierTo(w * .50, -h * .015, w * .62, h * .06)
      ..lineTo(w * .84, h * .18)
      ..quadraticBezierTo(w * .96, h * .23, w * .96, h * .35)
      ..lineTo(w * .94, h * .51)
      ..quadraticBezierTo(w * .92, h * .81, w * .61, h * .95)
      ..quadraticBezierTo(w * .50, h * 1.01, w * .39, h * .95)
      ..quadraticBezierTo(w * .08, h * .81, w * .06, h * .51)
      ..lineTo(w * .04, h * .35)
      ..quadraticBezierTo(w * .04, h * .23, w * .16, h * .18)
      ..close();
    final bounds = Offset.zero & size;
    canvas.drawPath(
      shield,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.bottomRight,
          end: Alignment.topLeft,
          colors: [light, light, dark],
        ).createShader(bounds),
    );
    canvas.drawPath(
      shield,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [light, dark],
        ).createShader(bounds)
        ..style = PaintingStyle.stroke
        ..strokeWidth = w * .065,
    );
  }

  @override
  bool shouldRepaint(_MedalPainter oldDelegate) =>
      oldDelegate.light != light || oldDelegate.dark != dark;
}
