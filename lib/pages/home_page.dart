import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_app/game/game.dart';
import 'package:go_app/widgets/board_widget.dart';

class HomePage extends StatelessWidget {
  final Game game;

  HomePage(this.game);

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
                  game.create(19);
                },
              ),
              BoardWidget()
            ],
          ),
        ),
      );
}
