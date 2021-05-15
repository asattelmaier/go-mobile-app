import 'package:flutter/cupertino.dart';
import 'package:go_app/game/end_game/end_game_controller.dart';
import 'package:go_app/game/end_game/winner/winner_controller.dart';
import 'package:go_app/game/end_game/winner/winner_view.dart';

class EndGameView extends StatelessWidget {
  final EndGameController _controller;

  EndGameView(this._controller);

  @override
  Widget build(_) => Center(
        child: Column(
          children: [
            WinnerView(WinnerController(_controller.winner)),
            Text('Score: ${_controller.score}')
          ],
        ),
      );
}
