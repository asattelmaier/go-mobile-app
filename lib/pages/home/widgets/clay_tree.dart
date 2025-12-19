import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'dart:math' as math;
import 'package:go_app/theme/clay_painting_mixin.dart';

class ClayTree extends StatefulWidget {
  final Color foliageColor;
  final double width;
  final double height;
  final bool showBranches;

  const ClayTree({
    Key? key,
    required this.foliageColor,
    this.width = 100,
    this.height = 160,
    this.showBranches = true,
  }) : super(key: key);

  @override
  _ClayTreeState createState() => _ClayTreeState();
}

class _ClayTreeState extends State<ClayTree> {
  late final _TreeConfiguration _config;

  @override
  void initState() {
    super.initState();
    _config = _TreeConfiguration.random();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(widget.width, widget.height),
      painter: _ClayTreePainter(
        color: widget.foliageColor,
        showBranches: widget.showBranches,
        config: _config,
      ),
    );
  }
}

/// Holds the randomized geometry of a single tree
class _TreeConfiguration {
  final double trunkTop;
  final double trunkBottom;
  final double leftBranchStartY;
  final double rightBranchStartY;
  final double leftBranchTipY;
  final double rightBranchTipY;
  final double leftBranchTipX;
  final double rightBranchTipX;

  _TreeConfiguration({
    required this.trunkTop,
    required this.trunkBottom,
    required this.leftBranchStartY,
    required this.rightBranchStartY,
    required this.leftBranchTipY,
    required this.rightBranchTipY,
    required this.leftBranchTipX,
    required this.rightBranchTipX,
  });

  factory _TreeConfiguration.random() {
    final random = math.Random();
    return _TreeConfiguration(
      trunkTop: 0.25 + random.nextDouble() * 0.15,
      trunkBottom: 0.85 + random.nextDouble() * 0.10,
      leftBranchStartY: 0.50 + random.nextDouble() * 0.30,
      rightBranchStartY: 0.50 + random.nextDouble() * 0.30,
      leftBranchTipY: 0.40 + random.nextDouble() * 0.15,
      rightBranchTipY: 0.40 + random.nextDouble() * 0.15,
      leftBranchTipX: 0.15 + random.nextDouble() * 0.10,
      rightBranchTipX: 0.15 + random.nextDouble() * 0.10,
    );
  }
}

class _ClayTreePainter extends CustomPainter with ClayPaintingMixin {
  final Color color;
  final bool showBranches;
  final _TreeConfiguration config;

  _ClayTreePainter({
    required this.color,
    required this.showBranches,
    required this.config,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Draw Foliage Body
    final path = Path()..addOval(Offset.zero & size);
    drawClaySurface(
      canvas: canvas, 
      path: path, 
      color: color, 
      pressedProgress: 0.0
    );

    // 2. Draw Branch Carvings
    if (showBranches) {
      _drawCarvings(canvas, size);
    }
  }

  void _drawCarvings(Canvas canvas, Size size) {
    // Define Branch Path
    final path = Path();
    final centerX = size.width / 2;
    
    // A. Trunk
    path.moveTo(centerX, size.height * config.trunkBottom);
    path.lineTo(centerX, size.height * config.trunkTop);
    
    // B. Left Branch
    _addBranch(
      path: path, 
      centerX: centerX, 
      size: size,
      startY: config.leftBranchStartY, 
      tipY: config.leftBranchTipY, 
      tipX: config.leftBranchTipX, 
      isLeft: true
    );
    
    // C. Right Branch
    _addBranch(
      path: path, 
      centerX: centerX, 
      size: size,
      startY: config.rightBranchStartY, 
      tipY: config.rightBranchTipY, 
      tipX: config.rightBranchTipX, 
      isLeft: false
    );

    // D. Render Grooves
    _paintGrooves(canvas, path, size.width);
  }

  void _addBranch({
    required Path path,
    required double centerX,
    required Size size,
    required double startY,
    required double tipY,
    required double tipX,
    required bool isLeft,
  }) {
    path.moveTo(centerX, size.height * startY);
    
    final direction = isLeft ? -1.0 : 1.0;
    
    // Control Point logic
    final controlX = centerX + (size.width * tipX * 0.3 * direction); 
    final controlY = size.height * ((startY + tipY) / 2 + 0.05); // slight sag
    
    final endX = centerX + (size.width * tipX * direction);
    final endY = size.height * tipY;

    path.quadraticBezierTo(controlX, controlY, endX, endY);
  }

  void _paintGrooves(Canvas canvas, Path path, double width) {
    final strokeWidth = width * 0.06;
    
    final strokePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    // 1. Base Darkening
    canvas.drawPath(path, strokePaint..color = Colors.black.withOpacity(0.3));

    // 2. Inner Shadow/Highlight helper
    void drawGrooveShadow(Offset offset, Color shadowColor) {
       canvas.saveLayer(null, Paint()); // Stencil
       canvas.drawPath(path, strokePaint); 

       // Cut away shifted copy
       canvas.saveLayer(null, Paint()..blendMode = BlendMode.dstOut);
       canvas.translate(offset.dx, offset.dy);
       canvas.saveLayer(null, Paint()..imageFilter = ui.ImageFilter.blur(sigmaX: 1.5, sigmaY: 1.5));
       canvas.drawPath(path, strokePaint..color = Colors.black);
       canvas.restore(); // blur
       canvas.restore(); // shift

       // Tint
       canvas.drawColor(shadowColor, BlendMode.srcIn);
       canvas.restore(); // End Stencil
    }

    // Shadow on Top-Left wall
    drawGrooveShadow(const Offset(1.5, 1.5), Colors.black.withOpacity(0.3));

    // Highlight on Bottom-Right wall
    drawGrooveShadow(const Offset(-1.5, -1.5), Colors.white.withOpacity(0.4));
  }

  @override
  bool shouldRepaint(covariant _ClayTreePainter oldDelegate) => 
    color != oldDelegate.color || config != oldDelegate.config;
}
