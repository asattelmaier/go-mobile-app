import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_app/game-session/game_session_controller.dart';
import 'package:go_app/game/game_controller.dart';
import 'package:go_app/game/game_view.dart';
import 'package:go_app/theme/go_theme.dart';
import 'package:go_app/widgets/bottom_action_bar/bottom_action_bar_controller.dart';
import 'package:go_app/widgets/bottom_action_bar/bottom_action_bar_view.dart';

class HomeView extends StatelessWidget {
  final GameSessionController _gameSessionController;
  final GameController _gameController;

  HomeView(this._gameSessionController, this._gameController);

  @override
  Widget build(BuildContext context) {
    final theme = GoTheme.of(context);

    return SafeArea(
        child: Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: GameView(_gameController),
      bottomNavigationBar: BottomActionBarView(_bottomActionBarController),
    ));
  }

  BottomActionBarController get _bottomActionBarController {
    log('Session ID: ${_gameSessionController.gameSessionId}');
    return BottomActionBarController(_gameSessionController, _gameController);
  }
}
