import 'package:flutter/material.dart';
import 'package:go_app/game/board/board_controller.dart';
import 'package:go_app/game/board/board_model.dart';
import 'package:go_app/game/board/board_view.dart';
import 'package:go_app/game/game_controller.dart';
import 'package:go_app/game/game_model.dart';

class GameView extends StatelessWidget {
  final GameController _controller;

  GameView(this._controller);

  @override
  Widget build(_) => Scaffold(
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
                builder: (_, game) => BoardView(game.hasData
                    ? BoardController(game.data!.board)
                    : BoardController(BoardModel.empty())),
              )
            ],
          ),
        ),
      );
}
