import 'package:flutter/material.dart';
import 'package:go_app/game-session/game_session_controller.dart';
import 'package:go_app/game-session/player/session_player_model.dart';
import 'package:go_app/game/game_controller.dart';
import 'package:go_app/game/player/player_color.dart';
import 'package:go_app/pages/game/widgets/player_info.dart';
import 'package:go_app/theme/go_theme.dart';

class GameHeader extends StatelessWidget {
  final GameSessionController gameSessionController;
  final GameController gameController;

  const GameHeader({
    Key? key,
    required this.gameSessionController,
    required this.gameController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = GoTheme.of(context);
    final players = gameSessionController.session.players;
    final blackPlayer = players.firstWhere(
        (p) => p.color == PlayerColor.Black,
        orElse: () => SessionPlayerModel.empty());
    final whitePlayer = players.firstWhere(
        (p) => p.color == PlayerColor.White,
        orElse: () => SessionPlayerModel.empty());

    final activeColor = gameController.activePlayer.color;
    final isGameOver = gameController.isGameOver;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start, // Align top to handle potential height diffs gracefully
        children: [
          PlayerInfo(
            player: blackPlayer, 
            isActive: activeColor == PlayerColor.Black,
            isGameOver: isGameOver,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 12.0), // Align VS with the stones
            child: Text(
              "VS",
              style: TextStyle(
                fontFamily: theme.fontFamily,
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
          ),
          PlayerInfo(
            player: whitePlayer, 
            isActive: activeColor == PlayerColor.White,
            isGameOver: isGameOver,
          ),
        ],
      ),
    );
  }
}
