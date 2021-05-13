import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_app/game/board.dart';
import 'package:go_app/game/game.dart';
import 'package:go_app/widgets/board_widget.dart';

class HomePage extends StatelessWidget {
  final Game _game;

  HomePage(this._game);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('Go'),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              ElevatedButton(
                child: Text('Start Game'),
                onPressed: () {
                  // TODO: Make magic numbers and strings configurable
                  _game.create(19);
                },
              ),
              StreamBuilder<Board>(
                stream: _game.board,
                builder: (context, snapshot) => BoardWidget(
                    snapshot.hasData ? snapshot.data! : Board.empty()),
              )
            ],
          ),
        ),
      );
}
