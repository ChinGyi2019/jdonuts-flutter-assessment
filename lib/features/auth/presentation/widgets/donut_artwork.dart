import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/theme/app_motion.dart';
import '../../../../core/widgets/entrance.dart';
import 'donut_circle.dart';

class DonutArtwork extends StatefulWidget {
  const DonutArtwork({
    required this.scrollColumns,
    required this.background,
    super.key,
  });

  final bool scrollColumns;
  final Color background;

  @override
  State<DonutArtwork> createState() => _DonutArtworkState();
}

class _DonutArtworkState extends State<DonutArtwork>
    with SingleTickerProviderStateMixin {
  late final _motion = AnimationController(vsync: this);

  static const _floatingDonuts = [
    (Offset(.24, .17), DonutCircleStyle.aqua),
    (Offset(.86, .29), DonutCircleStyle.lavender),
    (Offset(.24, .64), DonutCircleStyle.pink),
    (Offset(.86, .76), DonutCircleStyle.gold),
  ];

  static const _columns = [
    (
      center: .24,
      upward: true,
      styles: [DonutCircleStyle.aqua, DonutCircleStyle.pink],
    ),
    (
      center: .86,
      upward: false,
      styles: [DonutCircleStyle.lavender, DonutCircleStyle.gold],
    ),
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateMotion();
  }

  @override
  void didUpdateWidget(DonutArtwork oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.scrollColumns != widget.scrollColumns) {
      _motion.stop();
      _motion.value = 0;
      _updateMotion();
    }
  }

  void _updateMotion() {
    if (MediaQuery.disableAnimationsOf(context)) {
      _motion.stop();
      _motion.value = 0;
    } else if (!_motion.isAnimating) {
      _motion.repeat(
        period: widget.scrollColumns
            ? AppMotion.welcomeScroll
            : AppMotion.donutFloat,
      );
    }
  }

  @override
  void dispose() {
    _motion.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => IgnorePointer(
    child: ExcludeSemantics(
      child: RepaintBoundary(
        child: LayoutBuilder(
          builder: (_, constraints) => _scene(constraints.biggest),
        ),
      ),
    ),
  );

  Widget _scene(Size size) {
    final span = math.min(size.width, math.min(520.0, size.height * .82));
    final diameter = span * (widget.scrollColumns ? .55 : .52);
    final inset = (size.width - span) / 2 - diameter / 2;
    return Stack(
      fit: StackFit.expand,
      children: [
        const ColoredBox(color: Color(0xFFFFF9FC)),
        if (widget.scrollColumns)
          for (final column in _columns)
            Positioned(
              left: inset + column.center * span,
              top: 0,
              bottom: 0,
              width: diameter,
              child: _DonutColumn(
                motion: _motion,
                diameter: diameter,
                height: size.height,
                upward: column.upward,
                styles: column.styles,
              ),
            )
        else
          for (final (index, (center, style)) in _floatingDonuts.indexed)
            Positioned(
              left: inset + center.dx * span,
              top: center.dy * size.height - diameter / 2,
              width: diameter,
              height: diameter,
              child: _floatingCircle(index, diameter, style),
            ),
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: const [.68, .98],
              colors: [
                widget.background.withValues(alpha: 0),
                widget.background,
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _floatingCircle(int index, double diameter, DonutCircleStyle style) =>
      Entrance(
        order: index,
        offset: Offset(index.isEven ? -24 : 24, 16),
        child: AnimatedBuilder(
          animation: _motion,
          child: DonutCircle(style: style),
          builder: (_, child) {
            final phase = _motion.value * 2 * math.pi * (index.isEven ? 1 : 2);
            final start = index * 1.45;
            return Transform.translate(
              offset: Offset(
                (math.cos(phase + start) - math.cos(start)) * diameter * .016,
                (math.sin(phase + start) - math.sin(start)) * diameter * .025,
              ),
              child: child,
            );
          },
        ),
      );
}

class _DonutColumn extends StatelessWidget {
  const _DonutColumn({
    required this.motion,
    required this.diameter,
    required this.height,
    required this.upward,
    required this.styles,
  });

  final Animation<double> motion;
  final double diameter;
  final double height;
  final bool upward;
  final List<DonutCircleStyle> styles;

  @override
  Widget build(BuildContext context) {
    if (diameter <= 0) return const SizedBox.shrink();
    final gap = diameter * .22;
    final tileHeight = diameter * 1.48;
    final stride = tileHeight + gap;
    final cycle = stride * styles.length;
    final copies = (height / cycle).ceil() + 1;
    final start = upward ? diameter * .08 : cycle - gap;
    final direction = upward ? 1 : -1;

    return ClipRect(
      child: AnimatedBuilder(
        animation: motion,
        child: OverflowBox(
          alignment: Alignment.topCenter,
          minHeight: cycle * copies,
          maxHeight: cycle * copies,
          child: _strip(copies, gap, tileHeight),
        ),
        builder: (_, child) => Transform.translate(
          offset: Offset(
            0,
            -((start + direction * motion.value * cycle) % cycle),
          ),
          child: child,
        ),
      ),
    );
  }

  Widget _strip(int copies, double gap, double tileHeight) => Column(
    children: [
      for (var index = 0; index < copies * styles.length; index++)
        Padding(
          padding: EdgeInsets.only(bottom: gap),
          child: SizedBox(
            width: diameter,
            height: tileHeight,
            child: Entrance(
              order: index % styles.length * 2 + (upward ? 0 : 1),
              offset: Offset(upward ? -24 : 24, upward ? 16 : -16),
              child: DonutCircle(
                style: styles[index % styles.length],
                rectangular: true,
              ),
            ),
          ),
        ),
    ],
  );
}
