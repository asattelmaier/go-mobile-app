import 'dart:math' as math;

class BranchDefinition {
    final double y; // 0.0 to 1.0 relative to tree height
    final bool isLeft;
    final double length; // relative to tree width
    final double angle; // radians

    BranchDefinition({
        required this.y, 
        required this.isLeft, 
        required this.length, 
        required this.angle
    });
}

/// Holds the randomized geometry of a single tree
class TreeConfiguration {
  final double trunkTop;
  final double trunkBottom;
  final List<BranchDefinition> branches;

  TreeConfiguration({
    required this.trunkTop,
    required this.trunkBottom,
    required this.branches,
  });

  factory TreeConfiguration.fromSeed(int seed, {double treeHeight = 160.0}) {
    final random = math.Random(seed);
    
    final trunkBottom = 0.80 + random.nextDouble() * 0.10; // 0.85 to 0.95
    
    // Trunk length between 55% and 75% of tree height to avoid touching top
    final trunkLength = 0.55 + random.nextDouble() * 0.20; 
    final trunkTop = math.max(0.15, trunkBottom - trunkLength);
    
    // Generate Branches
    final branches = <BranchDefinition>[];
    
    // Visible range for branches: trunkTop to ~0.80 (20% from bottom)
    const visibleEnd = 0.80;
    
    // Determine number of "slots" or potential levels based on height
    // e.g. every 30px one level.
    final targetLevels = (treeHeight / 30.0).round();
    final levels = targetLevels.clamp(3, 8); // Minimum 3, max 8
    
    final usableHeight = visibleEnd - trunkTop;
    final step = usableHeight / levels;

    for (int i = 0; i < levels; i++) {
        final currentY = trunkTop + (step * i) + (step * 0.3); // slight offset
        
        // Probability to satisfy "natural" look
        // Higher up (smaller i) -> Short branches
        // Lower down -> Longer branches
        // Randomly skip sides
        
        final progress = i / levels; // 0.0 (top) to 1.0 (bottom of branch area)
        final baseLength = 0.12 + (progress * 0.08); // 0.12 to 0.20 width
        
        // Left Branch
        if (random.nextDouble() > 0.15) { // 85% chance
           branches.add(BranchDefinition(
             y: currentY + (random.nextDouble() * 0.02 - 0.01), // Jitter Y
             isLeft: true,
             length: baseLength + (random.nextDouble() * 0.05 - 0.025), // Jitter Length
             angle: -0.8 * math.pi + (random.nextDouble() * 0.2 - 0.1), // Jitter Angle (~ -144 deg)
           ));
        }

        // Right Branch
        if (random.nextDouble() > 0.15) { // 85% chance
           branches.add(BranchDefinition(
             y: currentY + (random.nextDouble() * 0.02 - 0.01),
             isLeft: false,
             length: baseLength + (random.nextDouble() * 0.05 - 0.025),
             angle: -0.2 * math.pi + (random.nextDouble() * 0.2 - 0.1), // (~ -36 deg)
           ));
        }
    }

    return TreeConfiguration(
      trunkTop: trunkTop,
      trunkBottom: trunkBottom,
      branches: branches,
    );
  }
}
