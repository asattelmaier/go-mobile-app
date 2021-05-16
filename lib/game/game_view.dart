import 'package:flutter/material.dart';
import 'package:go_app/game/board/board_controller.dart';
import 'package:go_app/game/board/board_view.dart';
import 'package:go_app/game/end_game/end_game_controller.dart';
import 'package:go_app/game/end_game/end_game_model.dart';
import 'package:go_app/game/end_game/end_game_view.dart';
import 'package:go_app/game/game_controller.dart';
import 'package:go_app/game/game_model.dart';
import 'package:go_app/theme/go_theme.dart';

class GameView extends StatelessWidget {
  final GoTheme _theme;
  final GameController _controller;

  GameView(this._controller, this._theme);

  @override
  Widget build(BuildContext context) => StreamBuilder<EndGameModel>(
        stream: _controller.endGame,
        builder: (_, endGame) {
          return StreamBuilder<GameModel>(
            stream: _controller.game,
            builder: (_, game) {
              if (!game.hasData) {
                return Container();
              }
              return Scaffold(
                backgroundColor: _theme.primaryLight,
                appBar: AppBar(
                  title: Text(
                    'Go',
                    style: TextStyle(color: _theme.primaryLight),
                  ),
                  backgroundColor: _theme.primaryDark,
                ),
                body: Center(
                  child: Column(
                    children: [
                      if (endGame.hasData) _endGame(endGame.data!),
                      if (game.data!.isPlaying) _board(context, game.data!),
                    ],
                  ),
                ),
                floatingActionButton: Visibility(
                  child: FloatingActionButton.extended(
                    elevation: 4.0,
                    icon: Icon(Icons.add, color: _theme.primaryLight),
                    label: Text(
                      'New Game',
                      style: TextStyle(color: _theme.primaryLight),
                    ),
                    backgroundColor: _theme.accent,
                    onPressed: () {
                      // TODO: Make magic numbers and strings configurable
                      _controller.create(9);
                    },
                  ),
                  visible: !game.data!.isPlaying,
                ),
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.centerDocked,
                bottomNavigationBar: PreferredSize(
                  preferredSize: Size.fromHeight(300),
                  child: BottomAppBar(
                    color: _theme.primaryDark,
                    child: new Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                          TextButton.icon(
                            label: Text('Pass'),
                            icon: Icon(Icons.block),
                            style: TextButton.styleFrom(primary: _theme.accent),
                            onPressed: () {
                              _controller.pass();
                            },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      );

  Widget _board(BuildContext context, GameModel game) {
    final controller = BoardController(_controller, game.board);
    final width = getBoardWidth(context);

    return Column(children: [
      BoardView(controller, _theme, width),
      Text('${game.activePlayer.toString()}s turn',
          style: TextStyle(color: _theme.primaryDark)),
    ]);
  }

  Widget _endGame(EndGameModel endGame) {
    return EndGameView(EndGameController(endGame));
  }

  double getBoardWidth(BuildContext context) =>
      MediaQuery.of(context).size.width;
}
