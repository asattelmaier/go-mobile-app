import 'package:flutter/material.dart' hide Router;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_app/game-session/game_session_controller.dart';
import 'package:go_app/layout/default/default_layout.dart';
import 'package:go_app/pages/game/game_page_view.dart';
import 'package:go_app/pages/home/home_page_view.dart';
import 'package:go_app/router/router.dart';
import 'package:go_app/theme/go_theme.dart';
import 'package:go_app/widgets/bottom_action_bar/buttons/cancel_button/cancel_button.dart';

class SessionPendingPageView extends StatelessWidget {
  final GameSessionController _gameSessionController;

  SessionPendingPageView(this._gameSessionController);

  @override
  Widget build(BuildContext context) {
    final borderWidth = GoTheme.of(context).borderWidth;
    final gutter = GoTheme.of(context).gutter;
    final waitingForPlayer = AppLocalizations.of(context)!.waitingForPlayer;

    _gameSessionController.onPlayerJoined((_) {
      Router.push(context, GamePageView(_gameSessionController));
    });

    return DefaultLayout(
      body: Align(
          alignment: Alignment.center,
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(waitingForPlayer, textAlign: TextAlign.center),
            Padding(
                padding: EdgeInsets.all(gutter * 6),
                child: CircularProgressIndicator(strokeWidth: borderWidth))
          ])),
      bottomActionBar: [
        CancelButtonView(() {
          _gameSessionController.terminateSession();
          Router.push(context, HomePageView(_gameSessionController));
        })
      ],
    );
  }
}
