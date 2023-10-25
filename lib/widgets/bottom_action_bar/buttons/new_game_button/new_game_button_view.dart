import 'package:flutter/material.dart' hide Router;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_app/game-session/client/game_session_client.dart';
import 'package:go_app/pages/new_game/create_game/create_game_page_view.dart';
import 'package:go_app/router/router.dart';
import 'package:go_app/user/user_controller.dart';

class NewGameButtonView extends StatelessWidget {
  final GameSessionClient _gameSessionClient;
  final UserController _userController;

  const NewGameButtonView(this._gameSessionClient, this._userController);

  @override
  Widget build(BuildContext context) => TextButton.icon(
        label: Text(AppLocalizations.of(context)!.newGame),
        icon: Icon(Icons.add),
        onPressed: () {
          Router.push(
              context, CreateGamePageView(_gameSessionClient, _userController));
        },
      );
}
