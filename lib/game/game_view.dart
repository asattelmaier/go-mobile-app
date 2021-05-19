import 'package:flutter/material.dart';
import 'package:go_app/game/board/board_controller.dart';
import 'package:go_app/game/board/board_view.dart';
import 'package:go_app/game/end_game/end_game_controller.dart';
import 'package:go_app/game/end_game/end_game_view.dart';
import 'package:go_app/game/game_controller.dart';
import 'package:go_app/theme/go_theme.dart';

class GameView extends StatelessWidget {
  final GoTheme _theme;
  final GameController _controller;

  GameView(this._controller, this._theme);

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Column(
          children: [
            if (_controller.isPlaying) _board(context),
            if (_controller.isPlaying && !_controller.isGameOver)
              Text('${_controller.activePlayer}s turn'),
            if (_controller.isGameOver) _endGame,
          ],
        ),
        bottomNavigationBar: PreferredSize(
          preferredSize: Size.fromHeight(300),
          child: BottomAppBar(
            color: _theme.primaryDark,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                TextButton.icon(
                  label: Text('New'),
                  icon: Icon(Icons.add),
                  style: TextButton.styleFrom(primary: _theme.accent),
                  onPressed: () {
                    // TODO: Make magic numbers and strings configurable
                    _controller.create(9);
                  },
                ),
                Visibility(
                  visible: _controller.isPlaying && !_controller.isGameOver,
                  child: TextButton.icon(
                    label: Text('Pass'),
                    icon: Icon(Icons.block),
                    style: TextButton.styleFrom(primary: _theme.accent),
                    onPressed: () {
                      _controller.pass();
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      );

  Widget _board(BuildContext context) {
    final controller = BoardController(_controller, _controller.board);
    final width = getBoardWidth(context);

    return Padding(
        padding: EdgeInsets.all(_theme.gutter * 2),
        child: Container(
          margin: EdgeInsets.only(top: _theme.gutter * 15),
          child: BoardView(controller, _theme, width),
        ));
  }

  Widget get _endGame {
    return EndGameView(EndGameController(_controller.endGame));
  }

  double getBoardWidth(BuildContext context) =>
      MediaQuery.of(context).size.width;
}
