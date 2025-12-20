import 'package:flutter/material.dart';

class Router {
  static Future push(BuildContext context, Widget route) {
    return Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (c, a1, a2) => route,
        transitionsBuilder: (c, anim, a2, child) {
          // Fade in the page content quickly (first 35% of 800ms approx 280ms)
          // letting the Hero animations continue for the full duration.
          return FadeTransition(
            opacity: CurvedAnimation(
              parent: anim,
              curve: Interval(0.0, 0.35, curve: Curves.easeOut),
            ),
            child: child,
          );
        },
        transitionDuration: Duration(milliseconds: 800),
      ),
    );
  }
}
