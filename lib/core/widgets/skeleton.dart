import 'package:flutter/material.dart';

import '../theme/app_motion.dart';

class Skeleton extends StatelessWidget {
  const Skeleton({
    required this.height,
    this.width = double.infinity,
    this.radius = 16,
    this.baseColor = SkeletonBlock.base,
    this.shimmerColor = SkeletonBlock.shimmer,
    super.key,
  });

  final double height;
  final double width;
  final double radius;
  final Color baseColor;
  final Color shimmerColor;

  @override
  Widget build(BuildContext context) => SkeletonShimmer(
    baseColor: baseColor,
    shimmerColor: shimmerColor,
    child: SkeletonBlock(
      height: height,
      width: width,
      radius: radius,
      color: baseColor,
    ),
  );
}

class SkeletonBlock extends StatelessWidget {
  const SkeletonBlock({
    required this.height,
    this.width = double.infinity,
    this.radius = 16,
    this.color,
    super.key,
  });

  static const base = Color(0xFFF2F4F7);

  /// Centre of the shimmer stripe. Pure white gives maximum contrast against
  /// [base] without introducing colour casts, producing the characteristic
  /// "gloss" effect seen in iOS and Material skeleton loaders.
  static const shimmer = Color(0xFFFFFFFF);

  /// Soft mid-tone used at the edges of the highlight band so the stripe
  /// blends smoothly into [base] instead of cutting in abruptly.
  static const shimmerEdge = Color(0xFFF8FAFC);

  final double height;
  final double width;
  final double radius;
  final Color? color;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: width,
    height: height,
    child: DecoratedBox(
      decoration: BoxDecoration(
        color: color ?? base,
        borderRadius: BorderRadius.circular(radius),
      ),
    ),
  );
}

class SkeletonShimmer extends StatefulWidget {
  const SkeletonShimmer({
    required this.child,
    this.baseColor = SkeletonBlock.base,
    this.shimmerColor = SkeletonBlock.shimmer,
    super.key,
  });

  final Widget child;
  final Color baseColor;
  final Color shimmerColor;

  @override
  State<SkeletonShimmer> createState() => _SkeletonShimmerState();
}

class _SkeletonShimmerState extends State<SkeletonShimmer>
    with SingleTickerProviderStateMixin {
  late final _phase = AnimationController(
    vsync: this,
    duration: AppMotion.shimmer,
    value: .22,
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context) || !TickerMode.of(context)) {
      _phase.stop();
    } else if (!_phase.isAnimating) {
      _phase.repeat();
    }
  }

  @override
  void dispose() {
    _phase.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ExcludeSemantics(
    child: RepaintBoundary(
      child: _phase.isAnimating
          ? AnimatedBuilder(
              animation: _phase,
              child: widget.child,
              builder: (_, child) => ShaderMask(
                blendMode: BlendMode.srcIn,
                shaderCallback: (bounds) => _gradient().createShader(bounds),
                child: child,
              ),
            )
          : widget.child,
    ),
  );

  /// Builds a narrow, sharp diagonal highlight band that sweeps left → right.
  ///
  /// The gradient is intentionally wider than the widget (extends to x = ±3
  /// in Alignment space) so the stripe enters and exits cleanly from the
  /// edges without abrupt appearance. Five stops keep the visible highlight
  /// band narrow (~20 % of the total span), giving a crisp, production-grade
  /// sweep rather than a broad, washed-out fade.
  LinearGradient _gradient() {
    // Ease the animation so the stripe accelerates out of the left edge and
    // decelerates into the right edge, matching Material shimmer behaviour.
    final t = Curves.easeInOut.transform(_phase.value);

    // cx moves from -3 (stripe fully left of the widget) to +3 (fully right).
    final cx = -3.0 + 6.0 * t;

    // Half-width of the full gradient span: the highlight occupies only the
    // central 20 % of this span (stops 0.4 → 0.6), so it looks razor-sharp.
    const half = 1.5;
    return LinearGradient(
      begin: Alignment(cx - half, -0.5),
      end: Alignment(cx + half, 0.5),
      // Five-stop ramp: base → edge mid-tone → pure-white centre → edge mid-tone → base.
      // The mid-tones prevent the white from "popping" abruptly while keeping the
      // overall stripe narrow enough to read as a crisp, diagonal sweep.
      colors: [
        widget.baseColor,
        SkeletonBlock.shimmerEdge,
        widget.shimmerColor,
        SkeletonBlock.shimmerEdge,
        widget.baseColor,
      ],
      stops: const [0.0, 0.38, 0.50, 0.62, 1.0],
    );
  }
}
