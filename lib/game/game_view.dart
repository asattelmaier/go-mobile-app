import 'package:flutter/material.dart';
import 'package:go_app/game/board/board_controller.dart';
import 'package:go_app/game/board/board_view.dart';
import 'package:go_app/game/end_game/end_game_controller.dart';
import 'package:go_app/game/end_game/end_game_view.dart';
import 'package:go_app/game/game_controller.dart';
import 'package:go_app/theme/go_theme.dart';

class GameView extends StatelessWidget {
  final GameController _controller;

  GameView(this._controller);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final theme = GoTheme.of(context);
    final gutter = theme.gutter;

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: Column(
        children: [
          if (_controller.isPlaying) _createBoard(width, gutter),
          if (_controller.isPlaying && !_controller.isGameOver)
            Text('${_controller.activePlayer}s turn'),
          if (_controller.isGameOver) _endGame,
        ],
      ),
      bottomNavigationBar: BottomAppBar(
          child: Padding(
        padding: EdgeInsets.only(
            top: gutter, bottom: gutter, left: gutter * 2, right: gutter * 2),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            TextButton.icon(
              label: Text('New'),
              icon: Icon(Icons.add),
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
                onPressed: () {
                  _controller.pass();
                },
              ),
            )
          ],
        ),
      )),
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
}
