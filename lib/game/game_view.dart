import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
    final theme = GoTheme.of(context);
    final gutter = theme.gutter;

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
    final player = _controller.activePlayer.isBlack
        ? AppLocalizations.of(context)!.black
        : AppLocalizations.of(context)!.white;

    return Text(AppLocalizations.of(context)!.playersTurn(player));
  }
}
