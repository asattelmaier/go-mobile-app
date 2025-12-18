import 'package:flutter/material.dart' hide Router;
import 'package:go_app/l10n/generated/app_localizations.dart';
import 'package:go_app/game-session/client/game_session_client.dart';
import 'package:go_app/game/settings/settings_model.dart';
import 'package:go_app/pages/new_game/game_pending/game_pending_page_view.dart';
import 'package:go_app/router/router.dart';
import 'package:go_app/user/user_controller.dart';

class CreateGameButton extends StatelessWidget {
  final GameSessionClient _gameSessionClient;
  final UserController _userController;
  final SettingsModel _settings;

  const CreateGameButton(
      this._gameSessionClient, this._userController, this._settings);

  @override
  Widget build(BuildContext context) => TextButton.icon(
        label: Text(AppLocalizations.of(context)!.createGame),
        icon: Icon(Icons.add),
        onPressed: () {
          Router.push(
              context,
              GamePendingPageView(
                  _gameSessionClient, _userController, _settings));
        },
      );
}
