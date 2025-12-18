import 'package:flutter/material.dart';
import 'package:go_app/l10n/generated/app_localizations.dart';
import 'package:go_app/game/board/board_controller.dart';
import 'package:go_app/game/board/board_view.dart';
import 'package:go_app/game/end_game/end_game_controller.dart';
import 'package:go_app/game/end_game/end_game_view.dart';
import 'package:go_app/game/game_controller.dart';
import 'package:go_app/theme/go_theme.dart';

class GameView extends StatelessWidget {
  final GameController _controller;

  const GameView(this._controller);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final gutter = GoTheme.of(context).gutter;

    return Column(
      children: [
        if (_controller.isPlaying) _createBoard(width, gutter),
        if (_controller.isPlaying && !_controller.isGameOver)
          _activePlayerInformation(context),
        if (_controller.isGameOver) _endGame,
      ],
    );
  }

  Widget _createBoard(double width, double gutter) {
    final controller = BoardController(_controller, _controller.board);

    return Padding(
        padding: EdgeInsets.all(gutter * 2),
        child: Container(
          margin: EdgeInsets.only(top: gutter * 15),
          child: BoardView(controller, width),
        ));
  }

  Widget get _endGame {
    return EndGameView(EndGameController(_controller.endGame));
  }

  Widget _activePlayerInformation(BuildContext context) {
    return Text(_controller.isPlayersTurn
        ? AppLocalizations.of(context)!.yourTurn
        : AppLocalizations.of(context)!.opponentsTurn);
  }
}
