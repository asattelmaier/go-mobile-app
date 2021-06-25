import 'package:flutter/material.dart' hide Router;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_app/game-session/game_session_controller.dart';
import 'package:go_app/game/settings/settings_model.dart';
import 'package:go_app/pages/new_game/game_pending/game_pending_page_view.dart';
import 'package:go_app/router/router.dart';

class CreateGameButton extends StatelessWidget {
  final GameSessionController _gameSessionController;
  final SettingsModel _settings;

  const CreateGameButton(this._gameSessionController, this._settings);

  @override
  Widget build(BuildContext context) => TextButton.icon(
        label: Text(AppLocalizations.of(context)!.createGame),
        icon: Icon(Icons.add),
        onPressed: () {
          _gameSessionController.createSession();

          Router.push(
              context, GamePendingPageView(_gameSessionController, _settings));
        },
      );
}
