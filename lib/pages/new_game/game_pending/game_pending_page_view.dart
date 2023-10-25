import 'package:flutter/material.dart' hide Router;
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_app/game-session/client/game_session_client.dart';
import 'package:go_app/game-session/game_session_controller.dart';
import 'package:go_app/game-session/game_session_model.dart';
import 'package:go_app/game/settings/settings_model.dart';
import 'package:go_app/layout/default/default_layout.dart';
import 'package:go_app/pages/game/game_page_view.dart';
import 'package:go_app/pages/home/home_page_view.dart';
import 'package:go_app/router/router.dart';
import 'package:go_app/theme/go_theme.dart';
import 'package:go_app/user/user_controller.dart';
import 'package:go_app/widgets/bottom_action_bar/buttons/cancel_button/cancel_button.dart';

class GamePendingPageView extends StatelessWidget {
  final GameSessionClient _gameSessionClient;
  final UserController _userController;
  final SettingsModel _settings;

  const GamePendingPageView(
      this._gameSessionClient, this._userController, this._settings);

  @override
  Widget build(BuildContext context) {
    final borderWidth = GoTheme.of(context).borderWidth;
    final gutter = GoTheme.of(context).gutter;
    final fontSizeSmall = GoTheme.of(context).fontSizeSmall;
    final waitingForPlayer = AppLocalizations.of(context)!.waitingForPlayer;
    final yourGameId = AppLocalizations.of(context)!.yourGameId;
    final gameIdInformation = AppLocalizations.of(context)!.gameIdInformation;
    final copiedToClipboard = AppLocalizations.of(context)!.copiedToClipboard;

    if (_userController.hasUser) {
      _gameSessionClient.createSession(_userController.user);
    }

    if (!_userController.hasUser) {
      _userController.createGuestUser().then(_gameSessionClient.createSession);
    }

    return StreamBuilder<GameSessionModel>(
        initialData: GameSessionModel.empty(),
        stream: _gameSessionClient.created,
        builder: (_, gameSessionModelSnapshot) {
          final gameSessionId = gameSessionModelSnapshot.data!.id;
          final isGameSessionEmpty = gameSessionModelSnapshot.data!.isEmpty;

          if (!isGameSessionEmpty) {
            _gameSessionClient
                .playerJoined(gameSessionId)
                .listen((GameSessionModel gameSession) {
              _gameSessionClient.terminated(gameSession.id).listen((_) {
                _gameSessionClient.dispose(gameSession.id);
              });
              Router.push(
                  context,
                  GamePageView(
                      GameSessionController(_gameSessionClient, gameSession,
                          gameSession.players.first),
                      _userController,
                      _settings));
            });
          }

          return DefaultLayout(
            body: Align(
                alignment: Alignment.center,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(waitingForPlayer, textAlign: TextAlign.center),
                      Padding(
                          padding: EdgeInsets.all(gutter * 6),
                          child: CircularProgressIndicator(
                              strokeWidth: borderWidth)),
                      Padding(
                          padding: EdgeInsets.only(
                              top: gutter * 12,
                              left: gutter * 6,
                              right: gutter * 6),
                          child: Column(children: [
                            Text(yourGameId, textAlign: TextAlign.center),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(gameSessionId,
                                    textAlign: TextAlign.center),
                                IconButton(
                                  icon: const Icon(Icons.copy),
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(copiedToClipboard)));
                                    Clipboard.setData(
                                        ClipboardData(text: gameSessionId));
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
                _gameSessionClient.terminateSession(gameSessionId);
                Router.push(
                    context, HomePageView(_gameSessionClient, _userController));
              })
            ],
          );
        });
  }
}
