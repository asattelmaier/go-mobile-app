import 'package:flutter/material.dart';
import 'package:go_app/widgets/clay_forest/clay_tree.dart';
import 'package:go_app/widgets/clay_forest/tree_configuration.dart';

class ClayForestHeader extends StatelessWidget {
  const ClayForestHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // Colors for easy cycling
    final c1 = theme.colorScheme.primary;
    final c2 = theme.colorScheme.secondary;
    final c3 = theme.colorScheme.tertiary;

    // Helper to keep code concise
    Widget _tree({
      required double left,
      required double bottom,
      required double width,
      required double height,
      required Color color,
      int seed = 0,
    }) {
      return Positioned(
        left: left,
        bottom: bottom,
        child: ClayTree(
          width: width,
          height: height,
          foliageColor: color,
          configuration: TreeConfiguration.fromSeed(seed, treeHeight: height),
        ),
      );
    }

    return SizedBox(
      height: 250, // Height of the header area
      width: double.infinity,
      child: ClipPath(
        clipper: _ForestHeaderClipper(),
        child: ShaderMask(
          shaderCallback: (rect) {
            return const LinearGradient(
              begin: Alignment.bottomCenter, // Fade out at the bottom
              end: Alignment.topCenter,
              colors: [Colors.transparent, Colors.black, Colors.black],
              stops: [0.05, 0.4, 1],
            ).createShader(rect);
          },
          blendMode: BlendMode.dstIn,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              // Constrain the forest composition to a mobile-like width and center it
              SizedBox(
                width: 390, 
                height: 250,
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  clipBehavior: Clip.none, 
                  children: [
                      // Back Layer
                      _tree(left: 0, bottom: 0, width: 100, height: 260, color: c3, seed: 1),
                      _tree(left: 200, bottom: -60, width: 150, height: 270, color: c2, seed: 2),
                      _tree(left: 300, bottom: -80, width: 140, height: 260, color: c3, seed: 4),

                      // Front Layer 
                      _tree(left: 60, bottom: -90, width: 140, height: 280, color: c2, seed: 5),
                      _tree(left: -120, bottom: -160, width: 170, height: 290, color: c1, seed: 6),
                      _tree(left: 200, bottom: -150, width: 150, height: 270, color: c3, seed: 7),
                      
                      // Far Edges
                      _tree(left: 10, bottom: -130, width: 140, height: 280, color: c1, seed: 8),
                      _tree(left: 130, bottom: -150, width: 120, height: 280, color: c2, seed: 9),
                      _tree(left: 280, bottom: -170, width: 120, height: 280, color: c2, seed: 10),

                      _tree(left: -30, bottom: -190, width: 140, height: 280, color: c1, seed: 11),
                      _tree(left: 200, bottom: -200, width: 160, height: 280, color: c2, seed: 12),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ForestHeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 22); 
    
    // Hill 1 (Wide, medium plateau)
    path.cubicTo(
      size.width * 0.10, size.height - 45, // Ctrl 1 (Up)
      size.width * 0.20, size.height - 45, // Ctrl 2 (Flatish top)
      size.width * 0.28, size.height - 22  // End
    );

    // Hill 2 (Narrower plateau)
    path.cubicTo(
      size.width * 0.33, size.height - 4, 
      size.width * 0.38, size.height - 4, 
      size.width * 0.45, size.height - 26   
    );

    // Hill 3 (Wide, deep plateau)
    path.cubicTo(
      size.width * 0.55, size.height - 56,  
      size.width * 0.65, size.height - 56,  
      size.width * 0.72, size.height - 18         
    );

    // Hill 4 (Short plateau)
    path.cubicTo(
      size.width * 0.78, size.height + 4,
      size.width * 0.82, size.height + 4,
      size.width * 0.88, size.height - 18         
    );

    // Hill 5 (Extra wide finish, off-screen)
    path.cubicTo(
      size.width * 0.95, size.height - 52,  
      size.width * 1.10, size.height - 52,  
      size.width * 1.15, size.height - 22         
    );

    path.lineTo(size.width, 0); 
    path.lineTo(0, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
