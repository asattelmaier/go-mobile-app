import 'package:flutter/material.dart';
import 'package:go_app/api/game/game_client.dart';
import 'package:go_app/api/web_socket/web_socket_client.dart';
import 'package:go_app/configuration/configuration.dart';
import 'package:go_app/game/game_controller.dart';
import 'package:go_app/game/game_view.dart';
import 'package:web_socket_channel/io.dart';

void main() {
  final channel = IOWebSocketChannel.connect(Configuration.WEB_SOCKET_URL);
  final controller = GameController(GameClient(WebSocketClient(channel)));

  runApp(GoApp(controller));
}

class GoApp extends StatelessWidget {
  final GameController _controller;

  GoApp(this._controller);

  @override
  Widget build(_) => MaterialApp(
        title: 'Go',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: GameView(_controller),
      );
}
