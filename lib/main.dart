import 'package:flutter/material.dart';
import 'package:go_app/api/game/game_client.dart';
import 'package:go_app/api/web_socket/web_socket_client.dart';
import 'package:go_app/configuration/configuration.dart';
import 'package:go_app/game/game.dart';
import 'package:go_app/pages/home_page.dart';
import 'package:web_socket_channel/io.dart';

void main() {
  final channel = IOWebSocketChannel.connect(Configuration.WEB_SOCKET_URL);
  final game = Game(GameClient(WebSocketClient(channel)));

  runApp(GoApp(game));
}

class GoApp extends StatelessWidget {
  final Game game;

  GoApp(this.game);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Go',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(game),
    );
  }
}
