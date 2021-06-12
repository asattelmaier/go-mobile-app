import 'package:flutter/material.dart' hide Router;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_app/game-session/game_session_controller.dart';
import 'package:go_app/pages/join_game/join_game_page_view.dart';
import 'package:go_app/router/router.dart';

class JoinGameButtonView extends StatelessWidget {
  final GameSessionController _gameSessionController;

  const JoinGameButtonView(this._gameSessionController);

  @override
  Widget build(BuildContext context) => TextButton.icon(
        label: Text(AppLocalizations.of(context)!.joinGame),
        icon: Icon(Icons.connect_without_contact),
        onPressed: () {
          Router.push(context, JoinGamePageView(_gameSessionController));
        },
      );
}
