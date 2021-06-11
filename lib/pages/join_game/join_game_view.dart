import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_app/game-session/game_session_controller.dart';

class JoinGameView extends StatelessWidget {
  final GameSessionController _gameSessionController;
  final _textEditingController = TextEditingController();

  JoinGameView(this._gameSessionController);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
          TextField(
            controller: _textEditingController,
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: AppLocalizations.of(context)!.enterGameSessionId),
          ),
          TextButton.icon(
            label: Text(AppLocalizations.of(context)!.join),
            icon: Icon(Icons.add),
            onPressed: () {
              _gameSessionController.joinSession(_textEditingController.text);
            },
          )
        ])));
  }
}
