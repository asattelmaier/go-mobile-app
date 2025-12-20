import 'package:flutter/material.dart';
import 'package:go_app/game-session/player/session_player_model.dart';
import 'package:go_app/game/player/player_color.dart';
import 'package:go_app/theme/go_theme.dart';

class PlayerInfo extends StatelessWidget {
  final SessionPlayerModel player;
  final bool isActive;
  final bool isGameOver;

  const PlayerInfo({
    Key? key,
    required this.player,
    required this.isActive,
    required this.isGameOver,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = GoTheme.of(context);
    final isBlack = player.color == PlayerColor.Black;
    final stoneColor = isBlack ? theme.blackStoneColor : theme.whiteStoneColor;
    final textColor = theme.colorScheme.onSurface;

    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: stoneColor,
              shape: BoxShape.circle,
              border: Border.all(
                color: isActive && !isGameOver
                    ? Colors.white // High contrast glow for both
                    : Colors.transparent,
                width: 3,
              ),
              boxShadow: [
                if (isActive && !isGameOver)
                  BoxShadow(
                    color: Colors.white.withValues(alpha: 0.8),
                    blurRadius: 15,
                    spreadRadius: 2,
                  ),
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  offset: Offset(2, 2),
                  blurRadius: 4,
                )
              ],
            ),
            child: Center(
              child: Text(
                player.id.isNotEmpty ? player.id[0].toUpperCase() : "?",
                style: TextStyle(
                  fontFamily: theme.fontFamily,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: isBlack
                      ? theme.colorScheme.onSecondary
                      : theme.colorScheme.onPrimary,
                ),
              ),
            ),
          ),
          SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Text(
              player.id.isNotEmpty ? player.id : "Waiting...",
              style: TextStyle(
                fontFamily: theme.fontFamily,
                fontSize: 14,
                fontWeight: FontWeight.bold, // Always bold to prevent jumping
                color: textColor,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              textAlign: TextAlign.center,
            ),
          ),
          // Reserve space for the dot even when not active
          Opacity(
            opacity: (isActive && !isGameOver) ? 1.0 : 0.0,
            child: Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
