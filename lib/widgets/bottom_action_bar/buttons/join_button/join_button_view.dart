import 'package:flutter/material.dart' hide Router;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_app/game-session/client/game_session_client.dart';

class JoinButtonView extends StatelessWidget {
  final GameSessionClient _gameSessionClient;
  final TextEditingController _textEditingController;

  const JoinButtonView(this._gameSessionClient, this._textEditingController);

  @override
  Widget build(BuildContext context) => TextButton.icon(
        label: Text(AppLocalizations.of(context)!.join),
        icon: Icon(Icons.connect_without_contact),
        onPressed: () {
          _gameSessionClient.joinSession(_textEditingController.text);
        },
      );
}
