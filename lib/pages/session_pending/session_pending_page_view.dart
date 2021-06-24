import 'package:flutter/material.dart' hide Router;
import 'package:flutter/services.dart';
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
    final fontSizeSmall = GoTheme.of(context).fontSizeSmall;
    final waitingForPlayer = AppLocalizations.of(context)!.waitingForPlayer;
    final yourGameId = AppLocalizations.of(context)!.yourGameId;
    final gameIdInformation = AppLocalizations.of(context)!.gameIdInformation;

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
                child: CircularProgressIndicator(strokeWidth: borderWidth)),
            Padding(
                padding: EdgeInsets.only(
                    top: gutter * 12, left: gutter * 6, right: gutter * 6),
                child: Column(children: [
                  Text(yourGameId, textAlign: TextAlign.center),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(_gameSessionController.sessionId,
                          textAlign: TextAlign.center),
                      IconButton(
                        icon: const Icon(Icons.copy),
                        onPressed: () {
                          Clipboard.setData(ClipboardData(
                              text: _gameSessionController.sessionId));
                        },
                      ),
                    ],
                  ),
                  Padding(
                      padding: EdgeInsets.only(top: gutter * 3),
                      child: Text(
                        gameIdInformation,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: fontSizeSmall),
                      )),
                ]))
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
