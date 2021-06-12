import 'package:flutter/material.dart';
import 'package:go_app/game-session/game_session_controller.dart';
import 'package:go_app/layout/default/default_layout.dart';
import 'package:go_app/widgets/bottom_action_bar/buttons/join_game_button/join_game_button_view.dart';
import 'package:go_app/widgets/bottom_action_bar/buttons/new_game_button/new_game_button_view.dart';

class HomePageView extends StatelessWidget {
  final GameSessionController _gameSessionController;

  HomePageView(this._gameSessionController);

  @override
  Widget build(BuildContext context) => DefaultLayout(
        body: Stack(
          children: [],
        ),
        bottomActionBar: [
          NewGameButtonView(_gameSessionController),
          JoinGameButtonView(_gameSessionController),
        ],
      );
}
