import 'package:flutter/material.dart' hide Router;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_app/game-session/game_session_controller.dart';

class JoinButtonView extends StatelessWidget {
  final GameSessionController _gameSessionController;
  final TextEditingController _textEditingController;

  const JoinButtonView(
      this._gameSessionController, this._textEditingController);

  @override
  Widget build(BuildContext context) => TextButton.icon(
        label: Text(AppLocalizations.of(context)!.join),
        icon: Icon(Icons.connect_without_contact),
        onPressed: () {
          _gameSessionController.joinSession(_textEditingController.text);
        },
      );
}
