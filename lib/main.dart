import 'package:flutter/material.dart';
import 'package:go_app/api/web_socket/web_socket_client.dart';
import 'package:go_app/configuration/configuration.dart';
import 'package:go_app/game/client/game_client.dart';
import 'package:go_app/game/end_game/end_game_model.dart';
import 'package:go_app/game/game_controller.dart';
import 'package:go_app/game/game_model.dart';
import 'package:go_app/game/game_view.dart';
import 'package:go_app/theme/go_theme.dart';
import 'package:web_socket_channel/io.dart';

void main() {
  final channel = IOWebSocketChannel.connect(Configuration.WEB_SOCKET_URL);
  final client = GameClient(WebSocketClient(channel));
  final theme = GoTheme();

  runApp(GoApp(client, theme));
}

class GoApp extends StatelessWidget {
  final GameClient _client;
  final GoTheme _theme;

  GoApp(this._client, this._theme);

  @override
  Widget build(_) => MaterialApp(
      title: 'Go',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Container(
        color: _theme.primaryLight,
        child: SafeArea(
            child: StreamBuilder<EndGameModel>(
          stream: _client.endGame,
          builder: (_, endGameSnapshot) => StreamBuilder<GameModel>(
            stream: _client.game,
            builder: (_, gameSnapshot) {
              final game = GameModel.fromNullable(gameSnapshot.data);
              final endGame = EndGameModel.fromNullable(endGameSnapshot.data);

              return GameView(GameController(_client, game, endGame), _theme);
            },
          ),
        )),
      ));
}
