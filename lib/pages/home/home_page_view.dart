import 'package:flutter/material.dart';
import 'package:go_app/game-session/client/game_session_client.dart';
import 'package:go_app/layout/default/default_layout.dart';
import 'package:go_app/theme/go_theme.dart';
import 'package:go_app/user/user_controller.dart';
import 'package:go_app/widgets/bottom_action_bar/buttons/join_game_button/join_game_button_view.dart';
import 'package:go_app/widgets/bottom_action_bar/buttons/new_game_button/new_game_button_view.dart';

class HomePageView extends StatelessWidget {
  final GameSessionClient _gameSessionClient;
  final UserController _userController;

  HomePageView(this._gameSessionClient, this._userController);

  @override
  Widget build(BuildContext context) => DefaultLayout(
        body: Stack(children: [
          Padding(
              padding: EdgeInsets.all(GoTheme.of(context).gutter * 6),
              child: Text(_userController.user.username)),
        ]),
        bottomActionBar: [
          NewGameButtonView(_gameSessionClient, _userController),
          JoinGameButtonView(_gameSessionClient, _userController),
        ],
      );
}
