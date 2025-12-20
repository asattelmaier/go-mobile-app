import 'package:flutter/material.dart';
import 'package:go_app/game/board/board_controller.dart';
import 'package:go_app/game/board/board_view.dart';
import 'package:go_app/game/end_game/end_game_controller.dart';
import 'package:go_app/game/end_game/end_game_view.dart';
import 'package:go_app/game/game_controller.dart';
import 'package:go_app/theme/go_theme.dart';
import 'package:go_app/widgets/clay_card/clay_card.dart';

class GameView extends StatelessWidget {
  final GameController _controller;

  const GameView(this._controller);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final gutter = GoTheme.of(context).gutter;

    if (_controller.isGameOver) {
      return _endGame;
    }

    if (_controller.isPlaying) {
      return Center(child: _createBoard(context, width, gutter));
    }

    return Container();
  }

  Widget _createBoard(BuildContext context, double width, double gutter) {
    final controller = BoardController(_controller, _controller.board);
    // Use more padding for the "slab" effect
    final double padding = gutter * 3;
    final boardWidth = width - (padding * 2);

    return Padding(
        padding: EdgeInsets.all(padding),
        child: AspectRatio(
          aspectRatio: 1.0,
          child: ClayCard(
            color: GoTheme.of(context).boardColor,
            borderRadius: 40,
            child: Padding(
              padding: EdgeInsets.all(gutter),
              child: BoardView(controller),
            ),
          ),
        ));
  }

  Widget get _endGame {
    return EndGameView(EndGameController(_controller.endGame));
  }
}
