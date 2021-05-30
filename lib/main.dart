import 'package:flutter/material.dart';
import 'package:go_app/api/web_socket/web_socket_client.dart';
import 'package:go_app/configuration/configuration.dart';
import 'package:go_app/environment/environment.dart';
import 'package:go_app/game-session/client/game_session_client.dart';
import 'package:go_app/game/client/game_client.dart';
import 'package:go_app/game/end_game/end_game_model.dart';
import 'package:go_app/game/game_controller.dart';
import 'package:go_app/game/game_model.dart';
import 'package:go_app/game/game_view.dart';
import 'package:go_app/l10n/l10n.dart';
import 'package:go_app/theme/go_theme.dart';

main() async {
  final environment = Environment();
  final configuration = Configuration.create(environment);
  final url = configuration.webSocketUrl;
  final webSocketClient = await WebSocketClient.connect(url);
  final gameSessionClient = GameSessionClient(webSocketClient);
  final gameClient = GameClient(gameSessionClient);
  final l10n = L10n();

  runApp(GoApp(gameClient, l10n));
}

class GoApp extends StatelessWidget {
  final GameClient _client;
  final L10n _l10n;

  const GoApp(this._client, this._l10n);

  @override
  Widget build(_) {
    return GoTheme(child: Builder(
      builder: (BuildContext context) {
        final theme = GoTheme.of(context);

        return MaterialApp(
            theme: theme.themeData,
            localizationsDelegates: _l10n.localizationDelegates,
            supportedLocales: _l10n.supportedLocales,
            home: Container(
              color: theme.colorScheme.background,
              child: SafeArea(
                  child: StreamBuilder<EndGameModel>(
                stream: _client.endGame,
                builder: (_, endGameSnapshot) => StreamBuilder<GameModel>(
                  stream: _client.game,
                  builder: (_, gameSnapshot) {
                    final game = GameModel.fromNullable(gameSnapshot.data);
                    final endGame =
                        EndGameModel.fromNullable(endGameSnapshot.data);

                    return GameView(GameController(_client, game, endGame));
                  },
                ),
              )),
            ));
      },
    ));
  }
}
