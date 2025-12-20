import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'dart:math' as math;
import 'package:go_app/theme/clay_painting_mixin.dart';
import 'package:go_app/widgets/clay_forest/tree_configuration.dart';

class ClayTree extends StatelessWidget {
  final Color foliageColor;
  final double width;
  final double height;
  final bool showBranches;
  final TreeConfiguration configuration;

  const ClayTree({
    Key? key,
    required this.foliageColor,
    required this.configuration,
    this.width = 100,
    this.height = 160,
    this.showBranches = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(width, height),
      painter: _ClayTreePainter(
        color: foliageColor,
        showBranches: showBranches,
        config: configuration,
      ),
    );
  }
}

class _ClayTreePainter extends CustomPainter with ClayPaintingMixin {
  final Color color;
  final bool showBranches;
  final TreeConfiguration config;

  _ClayTreePainter({
    required this.color,
    required this.showBranches,
    required this.config,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Draw Foliage Body
    final path = Path()..addOval(Offset.zero & size);
    drawClaySurface(
      canvas: canvas,
      path: path,
      color: color,
    );

    // Draw Branch Carvings
    if (showBranches) {
      _drawCarvings(canvas, size);
    }
  }

  void _drawCarvings(Canvas canvas, Size size) {
    final path = Path();
    final centerX = size.width / 2;
    
    path.moveTo(centerX, size.height * config.trunkBottom);
    path.lineTo(centerX, size.height * config.trunkTop);
    
    for (final branch in config.branches) {
        _addBranch(
            path: path,
            centerX: centerX,
            centerY: size.height * branch.y,
            width: size.width,
            branch: branch
        );
    }

    _paintGrooves(canvas, path, size.width * 0.06);
  }

  void _addBranch({
    required Path path,
    required double centerX,
    required double centerY,
    required double width,
    required BranchDefinition branch,
  }) {
    path.moveTo(centerX, centerY);
    
    final lengthPx = width * branch.length;
    
    final dx = math.cos(branch.angle) * lengthPx;
    final dy = math.sin(branch.angle) * lengthPx;

    path.relativeLineTo(dx, dy);
  }

  void _paintGrooves(Canvas canvas, Path path, double desiredStrokeWidth) {
    final strokeWidth = math.min(desiredStrokeWidth, 6.0);

    final bounds = path.getBounds().inflate(strokeWidth + 10.0);

    final strokePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(path, strokePaint..color = Colors.black.withValues(alpha: 0.5));

    void drawGrooveShadow(Offset offset, Color shadowColor) {
       canvas.saveLayer(bounds, Paint());
       canvas.drawPath(path, strokePaint); 

       canvas.saveLayer(bounds, Paint()..blendMode = BlendMode.dstOut);
       canvas.translate(offset.dx, offset.dy);
       canvas.saveLayer(bounds, Paint()..imageFilter = ui.ImageFilter.blur(sigmaX: 1.5, sigmaY: 1.5));
       canvas.drawPath(path, strokePaint..color = Colors.black);
       canvas.restore();
       canvas.restore();

       canvas.drawColor(shadowColor, BlendMode.srcIn);
       canvas.restore();
    }

    drawGrooveShadow(const Offset(1.5, 1.5), Colors.black.withValues(alpha: 0.3));

    drawGrooveShadow(const Offset(-1.5, -1.5), Colors.white.withValues(alpha: 0.4));
  }

  @override
  bool shouldRepaint(covariant _ClayTreePainter oldDelegate) => 
    color != oldDelegate.color || config != oldDelegate.config;
}
