import 'package:flutter/material.dart';
import 'package:go_app/theme/clay_painting_mixin.dart';

class ClayText extends StatelessWidget {
  final String text;
  final TextStyle style;
  final Color baseColor;

  const ClayText({
    Key? key,
    required this.text,
    required this.style,
    required this.baseColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 1. Invisible Layout Guide
        Text(
          text,
          style: style.copyWith(color: Colors.transparent),
        ),

        // 2. All-in-One Renderer
        Positioned.fill(
          child: CustomPaint(
            painter: _InnerShadowPainter(
              text: text,
              style: style,
              baseColor: baseColor,
            ),
          ),
        ),
      ],
    );
  }
}

class _InnerShadowPainter extends CustomPainter with ClayPaintingMixin {
  final String text;
  final TextStyle style;
  final Color baseColor;

  _InnerShadowPainter({
    required this.text,
    required this.style,
    required this.baseColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Layout Text exactly filling the available size
    final textPainter = TextPainter(
      text: TextSpan(text: text, style: style.copyWith(color: baseColor)),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(minWidth: size.width, maxWidth: size.width);

    drawClayTextSurface(
      canvas: canvas, 
      textPainter: textPainter, 
      color: baseColor, 
      width: size.width
    );
  }

  @override
  bool shouldRepaint(covariant _InnerShadowPainter oldDelegate) => 
      baseColor != oldDelegate.baseColor || 
      text != oldDelegate.text || 
      style != oldDelegate.style;
}
