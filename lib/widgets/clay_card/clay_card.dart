import 'package:flutter/material.dart';
import 'package:go_app/theme/clay_painting_mixin.dart';

class ClayCard extends StatelessWidget {
  final Widget child;
  final Color color;
  final double width;
  final double height;
  final double borderRadius;
  final bool isPressed;
  final bool hasDropShadow;

  const ClayCard({
    Key? key,
    required this.child,
    this.color = Colors.white,
    this.width = double.infinity,
    this.height = double.infinity,
    this.borderRadius = 20.0,
    this.isPressed = false,
    this.hasDropShadow = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _ClayCardPainter(
        color: color,
        borderRadius: borderRadius,
        hasDropShadow: hasDropShadow,
        isPressed: isPressed,
      ),
      child: Container(
        width: width,
        height: height,
        child: child,
      ),
    );
  }
}

class _ClayCardPainter extends CustomPainter with ClayPaintingMixin {
  final Color color;
  final double borderRadius;
  final bool hasDropShadow;
  final bool isPressed;

  _ClayCardPainter({
    required this.color,
    required this.borderRadius,
    required this.hasDropShadow,
    this.isPressed = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(borderRadius));

    drawClaySurface(
      canvas: canvas,
      path: Path()..addRRect(rrect),
      color: color,
      pressedProgress: isPressed ? 1.0 : 0.0,
      hasDropShadow: hasDropShadow,
    );
  }

  @override
  bool shouldRepaint(covariant _ClayCardPainter oldDelegate) {
    return color != oldDelegate.color ||
        borderRadius != oldDelegate.borderRadius ||
        isPressed != oldDelegate.isPressed ||
        hasDropShadow != oldDelegate.hasDropShadow;
  }
}
