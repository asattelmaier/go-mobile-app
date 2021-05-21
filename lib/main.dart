import 'package:flutter/material.dart';
import 'package:go_app/api/web_socket/web_socket_client.dart';
import 'package:go_app/configuration/configuration.dart';
import 'package:go_app/environment/environment.dart';
import 'package:go_app/game/client/game_client.dart';
import 'package:go_app/game/end_game/end_game_model.dart';
import 'package:go_app/game/game_controller.dart';
import 'package:go_app/game/game_model.dart';
import 'package:go_app/game/game_view.dart';
import 'package:go_app/theme/go_theme.dart';
import 'package:web_socket_channel/io.dart';

main() {
  final environment = Environment();
  final configuration = Configuration.create(environment);
  final channel = IOWebSocketChannel.connect(configuration.webSocketUrl);
  final client = GameClient(WebSocketClient(channel));

  runApp(GoApp(client));
}

class GoApp extends StatelessWidget {
  final GameClient _client;

  GoApp(this._client);

  @override
  Widget build(_) {
    return GoTheme(child: Builder(
      builder: (BuildContext context) {
        final theme = GoTheme.of(context);

        return MaterialApp(
            title: 'Go',
            theme: theme.themeData,
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
