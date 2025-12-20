import 'package:flutter/material.dart';
import 'dart:ui' as ui;

// --- Clay Physics Configuration ---
// Tweak these values to adjust the global Clay look and feel.

// 1. Drop Shadow
const _kDropShadowOffsetRest = Offset(10, 12);
const _kDropShadowOffsetPressed = Offset(6, 6);
const _kDropShadowBlur = 8.0;
const _kDropShadowScale = 0.95;
const _kDropShadowOpacityBase = 0.6;

// 2. Highlight (Top-Left)
const _kHighlightOpacityRest = 0.7;
const _kHighlightOpacityPressed = 0.4;
const _kHighlightOffsetRest = Offset(2, 4);
const _kHighlightOffsetPressed = Offset(-2, -4);
const _kHighlightBlurRest = 4.0;
const _kHighlightBlurPressed = 5.0;

// 3. Inner Shadow (Bottom-Right)
const _kInnerShadowOffsetRest = Offset(-2, -4);
const _kInnerShadowOffsetPressed = Offset(2, 4);
const _kInnerShadowBlurRest = 4.0;
const _kInnerShadowBlurPressed = 5.0;

// 4. Color Logic
const _kDropShadowLightnessShift = -0.35;
const _kDropShadowSaturationShift = 0.4;
const _kInnerShadowLightnessShift = -0.2;
const _kInnerShadowSaturationShift = 0.4;
const _kInnerShadowOpacity = 0.8;

/// Mixin that provides the standard "Inflated Clay" rendering pipeline.
mixin ClayPaintingMixin {

  /// Renders a shape with standard Claymorphic effects.
  void drawClaySurface({
    required Canvas canvas,
    required Path path,
    required Color color,
    double pressedProgress = 0.0,
    bool hasDropShadow = true,
  }) {
    final tOuter = pressedProgress;
    final tInner = pressedProgress;
    final inverseTOuter = 1.0 - tOuter;

    // --- 1. Calculate Animated Parameters ---
    
    // Drop Shadow (Outer Physics)
    final dropOffset = Offset.lerp(_kDropShadowOffsetRest, _kDropShadowOffsetPressed, tOuter)!; 
    final dropBlur = _kDropShadowBlur;
    
    // Highlight (Top-Left) (Inner Physics)
    final highlightOpacity = ui.lerpDouble(_kHighlightOpacityRest, _kHighlightOpacityPressed, tInner)!;
    final highlightOffset = Offset.lerp(_kHighlightOffsetRest, _kHighlightOffsetPressed, tInner)!;
    final highlightBlur = ui.lerpDouble(_kHighlightBlurRest, _kHighlightBlurPressed, tInner)!;

    // Inner Shadow (Bottom-Right) (Inner Physics)
    final shadowOffset = Offset.lerp(_kInnerShadowOffsetRest, _kInnerShadowOffsetPressed, tInner)!;
    final shadowBlur = ui.lerpDouble(_kInnerShadowBlurRest, _kInnerShadowBlurPressed, tInner)!;

    // Colors
    final dropShadowColor = _getDropShadowColor(color)
        .withOpacity(_kDropShadowOpacityBase * inverseTOuter + 0.4 * tOuter); 
    
    final innerShadowColor = _getInnerShadowColor(color);

    // --- 2. Render Pipeline ---

    // A. Drop Shadow
    // A. Drop Shadow
    if (hasDropShadow) {
      _drawDropShadow(
        canvas,
        path,
        dropShadowColor,
        offset: dropOffset,
        blur: dropBlur,
        scale: _kDropShadowScale,
      );
    }

    // B. Body
    canvas.drawPath(path, Paint()..color = color);

    // C. Inner Effects
    // Highlight
    _drawInnerCrescent(
      canvas,
      path, 
      Colors.white.withOpacity(highlightOpacity), 
      highlightOffset, 
      highlightBlur, 
      compositeMode: BlendMode.lighten
    );
    
    // Shadow
    _drawInnerCrescent(
      canvas,
      path, 
      innerShadowColor, 
      shadowOffset, 
      shadowBlur, 
      compositeMode: BlendMode.multiply
    );
  }

  void drawClayTextSurface({
    required Canvas canvas,
    required TextPainter textPainter,
    required Color color,
    required double width,
    double pressedProgress = 0.0,
    double depth = 4.0, 
    double blur = 5.0, 
  }) {
    final t = pressedProgress;
    final inverseT = 1.0 - t;

    // Drop Shadow
    final dropOffset = Offset.lerp(_kDropShadowOffsetRest, _kDropShadowOffsetPressed, t)!; 
    final dropBlur = _kDropShadowBlur;
    
    // Highlight (Top-Left)
    final highlightOpacity = ui.lerpDouble(_kHighlightOpacityRest, _kHighlightOpacityPressed, t)!;
    final highlightOffset = Offset.lerp(_kHighlightOffsetRest, _kHighlightOffsetPressed, t)!;
    final highlightBlur = ui.lerpDouble(_kHighlightBlurRest, _kHighlightBlurPressed, t)!;

    // Inner Shadow (Bottom-Right)
    final shadowOffset = Offset.lerp(_kInnerShadowOffsetRest, _kInnerShadowOffsetPressed, t)!;
    final shadowBlur = ui.lerpDouble(_kInnerShadowBlurRest, _kInnerShadowBlurPressed, t)!;

    // Colors
    final dropShadowColor = _getDropShadowColor(color)
        .withOpacity(_kDropShadowOpacityBase * inverseT + 0.4 * t);
    
    final innerShadowColor = _getInnerShadowColor(color);

    // Helpers for Text
    final originalSpan = textPainter.text as TextSpan;
    final text = originalSpan.text!;
    final style = originalSpan.style!;

    void paintWithColor(Color c) {
      textPainter.text = TextSpan(text: text, style: style.copyWith(color: c));
      textPainter.layout(minWidth: width, maxWidth: width);
      textPainter.paint(canvas, Offset.zero);
    }
    
    // A. Drop Shadow
    canvas.saveLayer(null, Paint()..blendMode = BlendMode.multiply);
    canvas.translate(dropOffset.dx, dropOffset.dy);
    
    final center = Offset(width / 2, textPainter.height / 2); // Approximate center
    canvas.translate(center.dx, center.dy);
    canvas.scale(_kDropShadowScale);
    canvas.translate(-center.dx, -center.dy);
    
    canvas.saveLayer(null, Paint()..imageFilter = ui.ImageFilter.blur(sigmaX: dropBlur, sigmaY: dropBlur));
    
    paintWithColor(dropShadowColor);
    
    canvas.restore(); // blur
    canvas.restore(); // transform/blend
    
    // B. Body
    paintWithColor(color);
    
    // C. Inner Effects
    void drawTextCrescent(Offset shift, Color c, double blur, BlendMode mode) {
      canvas.saveLayer(null, Paint()..blendMode = mode);
      textPainter.paint(canvas, Offset.zero); // Mask

      canvas.saveLayer(null, Paint()..blendMode = BlendMode.dstOut);
      canvas.translate(shift.dx, shift.dy);
      canvas.saveLayer(null, Paint()..imageFilter = ui.ImageFilter.blur(sigmaX: blur, sigmaY: blur));
      textPainter.paint(canvas, Offset.zero); // Cutout
      canvas.restore(); // blur
      canvas.restore(); // shift

      canvas.drawColor(c, BlendMode.srcIn); // Tint
      canvas.restore(); // Mask
    }

    drawTextCrescent(highlightOffset, Colors.white.withOpacity(highlightOpacity), highlightBlur, BlendMode.lighten);
    drawTextCrescent(shadowOffset, innerShadowColor, shadowBlur, BlendMode.multiply);
    
    // Restore
    textPainter.text = originalSpan;
    textPainter.layout(minWidth: width, maxWidth: width);
  }

  // --- Static Helper Methods ---

  static Color _getDropShadowColor(Color baseColor) {
    final hsl = HSLColor.fromColor(baseColor);
    return hsl
        .withLightness((hsl.lightness + _kDropShadowLightnessShift).clamp(0.0, 1.0))
        .withSaturation((hsl.saturation + _kDropShadowSaturationShift).clamp(0.0, 1.0))
        .toColor()
        .withOpacity(0.6); 
  }

  static Color _getInnerShadowColor(Color baseColor) {
    final hsl = HSLColor.fromColor(baseColor);
    return hsl
        .withLightness((hsl.lightness + _kInnerShadowLightnessShift).clamp(0.0, 1.0))
        .withSaturation((hsl.saturation + _kInnerShadowSaturationShift).clamp(0.0, 1.0))
        .toColor()
        .withOpacity(_kInnerShadowOpacity);
  }

  static void _drawInnerCrescent(
    Canvas canvas, 
    Path path, 
    Color color, 
    Offset offset, 
    double blur, {
    BlendMode compositeMode = BlendMode.srcOver,
  }) {
    canvas.saveLayer(null, Paint()..blendMode = compositeMode);
    canvas.drawPath(path, Paint());

    canvas.saveLayer(null, Paint()..blendMode = BlendMode.dstOut);
    canvas.translate(offset.dx, offset.dy);
    
    canvas.saveLayer(null, Paint()..imageFilter = ui.ImageFilter.blur(sigmaX: blur, sigmaY: blur));
    canvas.drawPath(path, Paint());
    
    canvas.restore(); // blur
    canvas.restore(); // translation/dstOut

    canvas.drawColor(color, BlendMode.srcIn);
    
    canvas.restore(); // main stencil
  }

  static void _drawDropShadow(
    Canvas canvas, 
    Path path, 
    Color color, {
    Offset offset = const Offset(4, 8),
    double blur = 8.0,
    double scale = 0.95,
  }) {
    final bounds = path.getBounds();
    final center = bounds.center;

    canvas.saveLayer(null, Paint()..blendMode = BlendMode.multiply);
    canvas.translate(offset.dx, offset.dy);
    
    canvas.translate(center.dx, center.dy);
    canvas.scale(scale);
    canvas.translate(-center.dx, -center.dy);

    canvas.saveLayer(null, Paint()..imageFilter = ui.ImageFilter.blur(sigmaX: blur, sigmaY: blur));
    canvas.drawPath(path, Paint()..color = color);
    
    canvas.restore(); // blur
    canvas.restore(); // matrix/blend
  }
}
