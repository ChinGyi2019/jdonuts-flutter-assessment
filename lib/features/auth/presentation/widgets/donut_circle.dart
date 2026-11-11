import 'package:flutter/material.dart';

enum DonutCircleStyle {
  aqua(_Donut.glazed, Color(0xFFB8D9EB), Color(0xFF77CEE2)),
  lavender(_Donut.coconut, Color(0xFFD6E7F6), Color(0xFFEFCDE3)),
  pink(_Donut.pink, Color(0xFFF4E1D5), Color(0xFFF0B9D4)),
  gold(_Donut.sprinkle, Color(0xFFFFD875), Color(0xFFFFB52F));

  const DonutCircleStyle(this._donut, this._base, this._accent);

  final _Donut _donut;
  final Color _base;
  final Color _accent;
}

enum _Donut {
  coconut('coconut-donut'),
  sprinkle('sprinkle-donut'),
  glazed('reward-donut'),
  pink('welcome-pink');

  const _Donut(this.asset);

  final String asset;
}

class DonutCircle extends StatelessWidget {
  const DonutCircle({required this.style, this.rectangular = false, super.key});

  final DonutCircleStyle style;
  final bool rectangular;

  _Donut get _donut => style._donut;

  @override
  Widget build(BuildContext context) {
    final artwork = DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: const Alignment(.25, -1),
          end: const Alignment(-.25, 1),
          stops: const [.66, .66],
          colors: [style._base, style._accent],
        ),
      ),
      child: CustomPaint(
        painter: _Sprinkles(style._accent),
        child: Stack(
          alignment: Alignment.center,
          fit: StackFit.expand,
          children: [
            const Align(
              alignment: Alignment(0, .55),
              child: FractionallySizedBox(
                widthFactor: .66,
                heightFactor: .26,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      colors: [Color(0x403A1923), Color(0x003A1923)],
                    ),
                  ),
                ),
              ),
            ),
            Center(
              child: FractionallySizedBox(
                widthFactor: _donut == _Donut.glazed ? .63 : .88,
                child: _photo(),
              ),
            ),
          ],
        ),
      ),
    );
    return rectangular
        ? ClipRRect(borderRadius: BorderRadius.circular(26), child: artwork)
        : ClipOval(child: artwork);
  }

  Widget _photo() {
    final image = Image.asset(
      'assets/images/${_donut.asset}${_donut == _Donut.pink ? '.png' : '.webp'}',
      fit: BoxFit.contain,
      excludeFromSemantics: true,
    );
    return _donut == _Donut.pink || _donut == _Donut.glazed
        ? image
        : ClipPath(clipper: _DonutOutline(_donut), child: image);
  }
}

class _Sprinkles extends CustomPainter {
  const _Sprinkles(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width, size.height);
    final paint = Paint()
      ..color = color.withValues(alpha: .85)
      ..strokeWidth = .026;
    canvas
      ..drawLine(const Offset(.09, .36), const Offset(.25, .23), paint)
      ..drawLine(const Offset(.48, .12), const Offset(.51, .28), paint)
      ..drawLine(const Offset(.96, .26), const Offset(.85, .38), paint)
      ..drawLine(const Offset(.11, .65), const Offset(.16, .52), paint)
      ..drawLine(const Offset(.81, .69), const Offset(.84, .51), paint)
      ..restore();
  }

  @override
  bool shouldRepaint(_Sprinkles oldDelegate) => color != oldDelegate.color;
}

// These two catalog photos are opaque. Their outlines use the source pixels.
class _DonutOutline extends CustomClipper<Path> {
  const _DonutOutline(this.donut);

  final _Donut donut;

  @override
  Path getClip(Size size) {
    final outline = donut == _Donut.coconut ? _coconut() : _sprinkle();
    return outline.transform(
      Matrix4.diagonal3Values(size.width / 414, size.height / 414, 1).storage,
    );
  }

  Path _coconut() => Path()
    ..fillType = PathFillType.evenOdd
    ..moveTo(62, 181)
    ..cubicTo(75, 108, 150, 61, 216, 61)
    ..cubicTo(290, 62, 341, 116, 353, 176)
    ..cubicTo(368, 259, 311, 322, 225, 328)
    ..cubicTo(141, 336, 62, 294, 65, 206)
    ..close()
    ..moveTo(181, 184)
    ..cubicTo(193, 169, 219, 167, 235, 176)
    ..cubicTo(247, 183, 246, 198, 233, 201)
    ..cubicTo(212, 204, 190, 199, 181, 184)
    ..close();

  Path _sprinkle() => Path()
    ..fillType = PathFillType.evenOdd
    ..moveTo(58, 180)
    ..cubicTo(73, 108, 149, 59, 218, 59)
    ..cubicTo(278, 62, 345, 117, 352, 176)
    ..cubicTo(365, 255, 312, 326, 228, 330)
    ..cubicTo(135, 336, 57, 279, 58, 180)
    ..close()
    ..moveTo(170, 193)
    ..cubicTo(177, 172, 216, 165, 232, 178)
    ..cubicTo(241, 184, 237, 196, 229, 200)
    ..cubicTo(207, 207, 187, 201, 170, 193)
    ..close();

  @override
  bool shouldReclip(_DonutOutline oldClipper) => donut != oldClipper.donut;
}
