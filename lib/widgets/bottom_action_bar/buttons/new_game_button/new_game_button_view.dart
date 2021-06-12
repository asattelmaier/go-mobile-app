import 'package:flutter/material.dart' hide Router;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_app/game-session/game_session_controller.dart';
import 'package:go_app/pages/session_pending/session_pending_page_view.dart';
import 'package:go_app/router/router.dart';

class NewGameButtonView extends StatelessWidget {
  final GameSessionController _gameSessionController;

  const NewGameButtonView(this._gameSessionController);

  @override
  Widget build(BuildContext context) => TextButton.icon(
        label: Text(AppLocalizations.of(context)!.newGame),
        icon: Icon(Icons.add),
        onPressed: () {
          _gameSessionController.createSession();

          Router.push(context, SessionPendingPageView(_gameSessionController));
        },
      );
}
