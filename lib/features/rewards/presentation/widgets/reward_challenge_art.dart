import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/media/catalog_image.dart';
import '../../../../core/theme/app_motion.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/reward_challenge.dart';

class RewardChallengeArt extends StatefulWidget {
  const RewardChallengeArt({
    required this.challenge,
    required this.entrance,
    super.key,
  });

  final RewardChallenge challenge;
  final Animation<double> entrance;

  @override
  State<RewardChallengeArt> createState() => _RewardChallengeArtState();
}

class _RewardChallengeArtState extends State<RewardChallengeArt>
    with SingleTickerProviderStateMixin {
  AnimationController? _replay;

  void _play() {
    if (MediaQuery.disableAnimationsOf(context)) return;
    setState(() {
      _replay ??= AnimationController(
        vsync: this,
        duration: AppMotion.rewardsArtwork,
      );
      _replay!.forward(from: 0);
    });
  }

  @override
  void dispose() {
    _replay?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reducedMotion = MediaQuery.disableAnimationsOf(context);
    final animation = reducedMotion
        ? const AlwaysStoppedAnimation(1.0)
        : (_replay ?? widget.entrance);
    final child = AspectRatio(
      aspectRatio: 1,
      child: RepaintBoundary(child: _art(animation)),
    );
    if (reducedMotion) return ExcludeSemantics(child: child);
    final label = AppLocalizations.of(context)!.replayChallenge;
    return Semantics(
      button: true,
      label: label,
      onTap: _play,
      excludeSemantics: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        excludeFromSemantics: true,
        onTap: _play,
        child: child,
      ),
    );
  }

  Widget _art(Animation<double> animation) {
    final challenge = widget.challenge;
    final image = CatalogImage(reference: challenge.image, fit: BoxFit.contain);
    if (challenge.artwork == ChallengeArtwork.coffee) {
      return CustomPaint(
        painter: _CoffeeProgressPainter(animation, challenge.progress),
        child: Align(
          alignment: const Alignment(0, .77),
          child: FractionallySizedBox(
            heightFactor: .76,
            widthFactor: .56,
            child: image,
          ),
        ),
      );
    }
    return Stack(
      fit: StackFit.expand,
      children: [
        ColorFiltered(
          colorFilter: const ColorFilter.matrix(_unearnedFilter),
          child: image,
        ),
        ClipPath(
          clipper: _DonutQuarterReveal(animation, challenge.progress),
          child: image,
        ),
      ],
    );
  }
}

const _unearnedFilter = <double>[
  .20,
  .41,
  .07,
  0,
  82,
  .20,
  .41,
  .07,
  0,
  82,
  .20,
  .41,
  .07,
  0,
  82,
  0,
  0,
  0,
  1,
  0,
];

class _DonutQuarterReveal extends CustomClipper<Path> {
  _DonutQuarterReveal(this.animation, this.fraction) : super(reclip: animation);

  final Animation<double> animation;
  final double fraction;

  @override
  Path getClip(Size size) {
    if (fraction <= 0 || animation.value <= 0) return Path();
    final bounds = Offset.zero & size;
    final sweep = _revealedFraction();
    if (sweep >= 1) return Path()..addRect(bounds);
    final arc = Rect.fromCircle(
      center: bounds.center,
      radius: size.longestSide,
    );
    return Path()
      ..moveTo(bounds.center.dx, bounds.center.dy)
      ..arcTo(arc, -math.pi / 2, sweep * math.pi * 2, false)
      ..close();
  }

  double _revealedFraction() {
    final earnedQuarters = fraction * 4;
    final step = animation.value * earnedQuarters.ceil();
    final finished = step.floor();
    final current = ((step - finished) / .74).clamp(0.0, 1.0);
    return math.min(earnedQuarters, finished + current) / 4;
  }

  @override
  bool shouldReclip(_DonutQuarterReveal oldClipper) =>
      oldClipper.animation != animation || oldClipper.fraction != fraction;
}

class _CoffeeProgressPainter extends CustomPainter {
  _CoffeeProgressPainter(this.animation, this.fraction)
    : super(repaint: animation);

  final Animation<double> animation;
  final double fraction;

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = size.width * .10;
    final arc = Rect.fromCircle(
      center: Offset(size.width / 2, size.height * .49),
      radius: (size.width - stroke) / 2,
    );
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = stroke
      ..color = AppColors.catalogBackground;
    canvas.drawArc(arc, math.pi, math.pi, false, paint);
    final progress =
        AppMotion.entranceFade.transform(animation.value) * fraction;
    if (progress <= 0) return;
    paint.color = AppColors.catalogOrange;
    canvas.drawArc(arc, math.pi, math.pi * progress, false, paint);
  }

  @override
  bool shouldRepaint(_CoffeeProgressPainter oldDelegate) =>
      oldDelegate.animation != animation || oldDelegate.fraction != fraction;
}
