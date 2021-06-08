import 'dart:developer';

import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:go_app/api/web_socket/web_socket_client.dart';
import 'package:go_app/configuration/configuration.dart';
import 'package:go_app/environment/environment.dart';
import 'package:go_app/game-session/client/game_session_client.dart';
import 'package:go_app/game-session/game_session_controller.dart';
import 'package:go_app/game/client/game_client.dart';
import 'package:go_app/game/game_controller.dart';
import 'package:go_app/game/game_view.dart';
import 'package:go_app/l10n/l10n.dart';
import 'package:go_app/theme/go_theme.dart';
import 'package:go_app/widgets/bottom_action_bar/bottom_action_bar_controller.dart';
import 'package:go_app/widgets/bottom_action_bar/bottom_action_bar_view.dart';

main() async {
  final environment = Environment();
  final configuration = Configuration.create(environment);
  final url = configuration.webSocketUrl;
  final webSocketClient = await WebSocketClient.connect(url);
  final gameSessionClient = GameSessionClient(webSocketClient);
  final gameSessionController = GameSessionController(gameSessionClient);
  final gameClient = GameClient(gameSessionController);
  final gameController = GameController(gameClient);
  final l10n = L10n();

  runApp(GoApp(gameSessionController, gameController, l10n));
}

class GoApp extends StatelessWidget {
  final GameSessionController _gameSessionController;
  final GameController _gameController;
  final L10n _l10n;

  const GoApp(this._gameSessionController, this._gameController, this._l10n);

  @override
  Widget build(_) {
    return GoTheme(child: Builder(
      builder: (BuildContext context) {
        final theme = GoTheme.of(context);
        _gameSessionController.playerJoined.listen((event) {
          // TODO: Make this configurable
          _gameController.create(5, false);
        });

        return MaterialApp(
            theme: theme.themeData,
            localizationsDelegates: _l10n.localizationDelegates,
            supportedLocales: _l10n.supportedLocales,
            home: StreamBuilder(
              stream: StreamGroup.merge([
                _gameSessionController.updateStream,
                _gameController.updateStream
              ]),
              builder: (BuildContext context, _) => Container(
                  color: theme.colorScheme.background,
                  child: SafeArea(
                      child: Scaffold(
                    backgroundColor: theme.colorScheme.background,
                    body: GameView(_gameController),
                    bottomNavigationBar:
                        BottomActionBarView(_bottomActionBarController),
                  ))),
            ));
      },
    ));
  }

  BottomActionBarController get _bottomActionBarController {
    log('Session ID: ${_gameSessionController.gameSessionId}');
    return BottomActionBarController(_gameSessionController, _gameController);
  }
}
