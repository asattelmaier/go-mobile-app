import 'package:flutter/material.dart';
import 'package:go_app/theme/clay_painting_mixin.dart';
import 'package:go_app/theme/go_theme.dart';

class ClayButton extends StatefulWidget {
  static const double _defaultWidth = 200;
  static const double _defaultHeight = 50;
  static const Color _defaultColor = Color(0xFFFFA726);

  final String text;
  final VoidCallback onTap;
  final Color? color;
  final Color? textColor;
  final double? width;
  final double? height;
  final Widget? icon;

  const ClayButton({
    Key? key,
    required this.text,
    required this.onTap,
    this.color,
    this.textColor,
    this.width,
    this.height,
    this.icon,
  }) : super(key: key);

  @override
  _ClayButtonState createState() => _ClayButtonState();
}

class _ClayButtonState extends State<ClayButton> with SingleTickerProviderStateMixin {
  late double _scale;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 150),
      lowerBound: 0.0,
      upperBound: 0.05,
    )..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
    widget.onTap();
  }

  void _onTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    // Use font family from theme, but keep other button-specifics local
    final theme = GoTheme.of(context);
    
    final width = widget.width ?? ClayButton._defaultWidth;
    final height = widget.height ?? ClayButton._defaultHeight;
    final color = widget.color ?? ClayButton._defaultColor;
    
    final textStyle = TextStyle(
      fontFamily: theme.fontFamily,
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: widget.textColor ?? Colors.white,
      shadows: [
        Shadow(
          color: Colors.black.withValues(alpha: 0.1),
          offset: Offset(1, 1),
          blurRadius: 2,
        ),
      ],
    );

    _scale = 1 - _controller.value;
    final pressedProgress = _controller.value / 0.05; 
    
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: Transform.scale(
        scale: _scale,
        child: CustomPaint(
          painter: _ClayButtonPainter(
            color: color,
            pressedProgress: pressedProgress,
          ),
          child: Container(
            width: width,
            height: height,
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (widget.icon != null) ...[
                  widget.icon!,
                  SizedBox(width: 8),
                ],
                Text(
                  widget.text,
                  style: textStyle,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ClayButtonPainter extends CustomPainter with ClayPaintingMixin {
  final Color color;
  final double pressedProgress;

  _ClayButtonPainter({
    required this.color,
    required this.pressedProgress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(size.height / 2));
    final path = Path()..addRRect(rrect);

    drawClaySurface(
      canvas: canvas, 
      path: path, 
      color: color, 
      pressedProgress: pressedProgress
    );
  }

  @override
  bool shouldRepaint(covariant _ClayButtonPainter oldDelegate) => 
      color != oldDelegate.color || pressedProgress != oldDelegate.pressedProgress;
}
