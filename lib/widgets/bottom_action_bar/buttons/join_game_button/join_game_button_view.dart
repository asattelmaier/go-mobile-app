import 'package:flutter/material.dart' hide Router;
import 'package:go_app/l10n/generated/app_localizations.dart';
import 'package:go_app/game-session/client/game_session_client.dart';
import 'package:go_app/pages/join_game/join_game_page_view.dart';
import 'package:go_app/router/router.dart';
import 'package:go_app/user/user_controller.dart';

class JoinGameButtonView extends StatelessWidget {
  final GameSessionClient _gameSessionClient;
  final UserController _userController;

  const JoinGameButtonView(this._gameSessionClient, this._userController);

  @override
  Widget build(BuildContext context) => TextButton.icon(
        label: Text(AppLocalizations.of(context)!.joinGame),
        icon: Icon(Icons.connect_without_contact),
        onPressed: () {
          Router.push(context,
              JoinGamePageView(_gameSessionClient, this._userController));
        },
      );
}
