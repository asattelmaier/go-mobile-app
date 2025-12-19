import 'package:flutter/material.dart';
import 'package:go_app/pages/home/widgets/clay_tree.dart';

class ClayForest extends StatelessWidget {
  const ClayForest({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // Helper to keep code concise
    Widget _tree({
      required double left,
      required double bottom,
      required double width,
      required double height,
      required Color color,
      bool branches = true,
    }) {
      return Positioned(
        left: left,
        bottom: bottom,
        child: ClayTree(
          width: width,
          height: height,
          foliageColor: color,
          showBranches: branches,
        ),
      );
    }

    // Colors for easy cycling
    final c1 = theme.colorScheme.primary;
    final c2 = theme.colorScheme.secondary;
    final c3 = theme.colorScheme.tertiary;

    return SizedBox(
      width: 340,
      height: 220,
      child: ClipPath(
        clipper: _ForestBackdropClipper(),
        child: ShaderMask(
          shaderCallback: (rect) {
            return const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.black, Colors.black, Colors.transparent],
              stops: [0.0, 0.75, 0.9], // Restored original fade
            ).createShader(rect);
          },
          blendMode: BlendMode.dstIn,
          child: Transform.translate(
            offset: const Offset(5, -30),
            child: Stack(
              alignment: Alignment.bottomCenter,
              clipBehavior: Clip.none,
              // Preserving EXACT original Z-order (Top of list = Bottom of Stack = Back)
              children: [
                
                // --- Group 1: Left Cluster ---
                _tree(left: 50, bottom: 40, width: 35, height: 90, color: c3),
                _tree(left: 20, bottom: 20, width: 50, height: 60, color: c2),
                
                // --- Group 2: Center-Left ---
                _tree(left: 90, bottom: 0, width: 55, height: 75, color: c1),
                _tree(left: 60, bottom: 0, width: 45, height: 85, color: c3),
                
                // --- Group 3: Center Mid ---
                _tree(left: 140, bottom: 10, width: 60, height: 70, color: c3), // "Tree 5"
                _tree(left: 120, bottom: 0, width: 40, height: 95, color: c2),  // "Tree 6"
                
                // --- Group 4: Center-Right ---
                _tree(left: 170, bottom: 35, width: 30, height: 80, color: c3), // "Tree 8"
                _tree(left: 170, bottom: 0, width: 55, height: 65, color: c1),  // "Tree 7"
                _tree(left: 195, bottom: 20, width: 65, height: 60, color: c2), // "Tree 9"

                // --- Group 5: Far Right ---
                _tree(left: 270, bottom: 20, width: 40, height: 85, color: c3), // "Tree 12"
                _tree(left: 245, bottom: 15, width: 55, height: 70, color: c1), // "Tree 11"
                _tree(left: 220, bottom: 25, width: 45, height: 90, color: c2), // "Tree 10"

                // --- BUSHES (Foreground) ---
                _tree(left: -20, bottom: -100, width: 120, height: 140, color: c1, branches: false),
                _tree(left: 100, bottom: -110, width: 120, height: 140, color: c2, branches: false),
                _tree(left: 190, bottom: -110, width: 140, height: 160, color: c3, branches: false),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ForestBackdropClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    
    // Hill 1 (Right)
    path.quadraticBezierTo(
      size.width * 0.85, size.height - 70, 
      size.width * 0.7, size.height - 10
    );

    // Hill 2 (Center)
    path.quadraticBezierTo(
      size.width * 0.60, size.height - 70, 
      size.width * 0.50, size.height - 10
    );

    // Hill 3 (Left)
    path.quadraticBezierTo(
      size.width * 0.25, size.height - 70, 
      size.width * 0.15, size.height - 10 
    );

    path.quadraticBezierTo(
      size.width * 0.1, size.height - 60, 
      -20, size.height - 30 
    );

    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
