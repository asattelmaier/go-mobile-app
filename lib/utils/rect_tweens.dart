import 'package:flutter/material.dart';

/// A RectTween that applies an elastic curve to the interpolation.
/// This creates a "bouncy" effect for Hero transitions, matching the
/// clay/puffy aesthetic.
class BouncyRectTween extends RectTween {
  BouncyRectTween({super.begin, super.end});

  @override
  Rect? lerp(double t) {
    // heavy bounce: Curves.elasticOut
    // soft bounce: Curves.easeOutBack
    final curvedT = Curves.easeOutBack.transform(t);
    
    return Rect.lerp(begin, end, curvedT);
  }
}
