import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/reward_tier.dart';

class RewardPointsRing extends StatelessWidget {
  const RewardPointsRing({
    required this.progress,
    required this.animation,
    super.key,
  });

  final TierProgress progress;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    return Semantics(
      label:
          '${strings.totalRewardPoints} ${strings.rewardsPointsTotal(progress.points)}',
      excludeSemantics: true,
      child: Stack(
        fit: StackFit.expand,
        children: [
          RepaintBoundary(
            child: CustomPaint(
              painter: _FrostedRingPainter(animation, progress.fraction),
            ),
          ),
          Center(
            child: AnimatedBuilder(
              animation: animation,
              builder: (_, _) =>
                  _label(strings, (progress.points * animation.value).round()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _label(AppLocalizations strings, int points) => FractionallySizedBox(
    widthFactor: .56,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          strings.totalRewardPoints,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: AppColors.catalogPink,
          ),
        ),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            strings.rewardsPointsTotal(points),
            style: const TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.w700,
              color: AppColors.catalogPink,
            ),
          ),
        ),
      ],
    ),
  );
}

class _FrostedRingPainter extends CustomPainter {
  _FrostedRingPainter(this.animation, this.fraction)
    : super(repaint: animation);

  final Animation<double> animation;
  final double fraction;

  static const _start = -math.pi * .46;
  static const _turn = 2 * math.pi;
  static const _icing = RadialGradient(
    colors: [
      AppColors.catalogPink,
      AppColors.catalogPink,
      Color(0xFFF88CB8),
      Color(0xFFF14F9C),
    ],
    stops: [0, .57, .79, 1],
  );
  static final _sprinkles = _makeSprinkles();

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final diameter = size.shortestSide;
    final thickness = diameter * .21;
    final radius = (diameter - thickness) / 2;
    final ring = Rect.fromCircle(center: center, radius: radius);
    final paint = Paint()
      ..color = AppColors.catalogBackground
      ..style = PaintingStyle.stroke
      ..strokeWidth = thickness
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, paint);

    final sweep = _turn * fraction * animation.value;
    if (sweep <= 0) return;
    paint.shader = _icing.createShader(Offset.zero & size);
    canvas.drawArc(ring, _start, sweep, false, paint);
    _paintSprinkles(canvas, center, radius, thickness, sweep);
  }

  void _paintSprinkles(
    Canvas canvas,
    Offset center,
    double radius,
    double thickness,
    double sweep,
  ) {
    final paint = Paint()
      ..strokeWidth = thickness * .085
      ..strokeCap = StrokeCap.round;
    final end = _polar(_start + sweep, radius);
    final start = _polar(_start, radius);
    for (final (angle, depth, tilt, length) in _sprinkles) {
      final position = _polar(_start + angle, radius + thickness * depth);
      final capDistance = math.min(
        (position - start).distance,
        (position - end).distance,
      );
      if (angle > sweep && capDistance >= thickness * .35) continue;
      final half = _polar(tilt, thickness * length);
      paint.color = const Color(
        0xFFFFD4E8,
      ).withValues(alpha: .44 + depth.abs());
      canvas.drawLine(
        center + position - half,
        center + position + half,
        paint,
      );
    }
  }

  static Offset _polar(double angle, double radius) =>
      Offset(math.cos(angle) * radius, math.sin(angle) * radius);

  static List<(double, double, double, double)> _makeSprinkles() {
    final random = math.Random(17);
    return List.generate(
      29,
      (index) => (
        (index + random.nextDouble() * .45) * _turn / 29,
        (random.nextDouble() - .5) * .64,
        random.nextDouble() * math.pi,
        .10 + random.nextDouble() * .11,
      ),
    );
  }

  @override
  bool shouldRepaint(_FrostedRingPainter oldDelegate) =>
      oldDelegate.animation != animation || oldDelegate.fraction != fraction;
}
