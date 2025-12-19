import 'package:flutter/material.dart';

class HomeBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFFFD99B), // Base warm surface
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
           // Sky Gradient (Subtle)
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFFFD99B), // Very light Orange/Peach
                  Color(0xFFFFC894), // Deep Peach/Beige
                ],
                stops: [0.0, 1.0],
              ),
            ),
          ),
          

        ],
      ),
    );
  }
}


