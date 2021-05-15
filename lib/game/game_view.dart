import 'package:flutter/material.dart';
import 'package:go_app/game/board/board_controller.dart';
import 'package:go_app/game/board/board_view.dart';
import 'package:go_app/game/game_controller.dart';
import 'package:go_app/game/game_model.dart';

class GameView extends StatelessWidget {
  final GameController _controller;

  GameView(this._controller);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('Go'),
        ),
        body: Center(
          child: Column(
            children: [
              ElevatedButton(
                child: Text('Start Game'),
                onPressed: () {
                  // TODO: Make magic numbers and strings configurable
                  _controller.create(19);
                },
              ),
              StreamBuilder<GameModel>(
                stream: _controller.game,
                builder: (_, snapshot) {
                  final game = GameModel.fromNullable(snapshot.data);
                  final controller = BoardController(_controller, game.board);
                  final width = getBoardWidth(context);

                  return Column(children: [
                    BoardView(controller, width),
                    Text('${game.activePlayer.toString()}s turn')
                  ]);
                },
              )
            ],
          ),
        ),
      );

  double getBoardWidth(BuildContext context) =>
      MediaQuery.of(context).size.width;
}
