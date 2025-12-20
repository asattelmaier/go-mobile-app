import 'package:flutter/material.dart';
import 'package:go_app/theme/clay_painting_mixin.dart';

class ClayCard extends StatelessWidget {
  final Widget child;
  final Color color;
  final double width;
  final double height;
  final double borderRadius;

  const ClayCard({
    Key? key,
    required this.child,
    this.color = Colors.white,
    this.width = double.infinity,
    this.height = double.infinity,
    this.borderRadius = 20.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: CustomPaint(
        painter: _ClayCardPainter(
          color: color,
          borderRadius: borderRadius,
        ),
        child: Center(child: child),
      ),
    );
  }
}

class _ClayCardPainter extends CustomPainter with ClayPaintingMixin {
  final Color color;
  final double borderRadius;

  _ClayCardPainter({
    required this.color,
    required this.borderRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(borderRadius));

    drawClaySurface(
      canvas: canvas,
      path: Path()..addRRect(rrect),
      color: color,
    );
  }

  @override
  bool shouldRepaint(covariant _ClayCardPainter oldDelegate) {
    return color != oldDelegate.color || borderRadius != oldDelegate.borderRadius;
  }
}
