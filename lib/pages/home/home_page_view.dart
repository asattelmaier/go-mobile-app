import 'package:flutter/material.dart';
import 'package:go_app/game-session/client/game_session_client.dart';
import 'package:go_app/layout/default/default_layout.dart';
import 'package:go_app/widgets/bottom_action_bar/buttons/join_game_button/join_game_button_view.dart';
import 'package:go_app/widgets/bottom_action_bar/buttons/new_game_button/new_game_button_view.dart';

class HomePageView extends StatelessWidget {
  final GameSessionClient _gameSessionClient;

  HomePageView(this._gameSessionClient);

  @override
  Widget build(BuildContext context) => DefaultLayout(
        body: Stack(
          children: [],
        ),
        bottomActionBar: [
          NewGameButtonView(_gameSessionClient),
          JoinGameButtonView(_gameSessionClient),
        ],
      );
}
