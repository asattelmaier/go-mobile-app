import 'package:flutter/material.dart' hide Router;
import 'package:go_app/game-session/game_session_controller.dart';
import 'package:go_app/game/client/game_client.dart';
import 'package:go_app/game/end_game/end_game_model.dart';
import 'package:go_app/game/game_controller.dart';
import 'package:go_app/game/game_model.dart';
import 'package:go_app/game/game_view.dart';
import 'package:go_app/game/settings/settings_model.dart';
import 'package:go_app/layout/default/default_layout.dart';
import 'package:go_app/pages/home/home_page_view.dart';
import 'package:go_app/user/user_controller.dart';
import 'package:go_app/widgets/bottom_action_bar/buttons/back_button/back_button.dart';
import 'package:go_app/widgets/bottom_action_bar/buttons/pass_button/pass_button_view.dart';

class GamePageView extends StatelessWidget {
  final GameSessionController _gameSessionController;
  final SettingsModel _settings;
  final UserController _userController;

  GamePageView(this._gameSessionController, this._userController,
      [this._settings = const SettingsModel.empty()]);

  @override
  Widget build(BuildContext context) {
    final gameClient = GameClient(_gameSessionController);

    return StreamBuilder<EndGameModel>(
        initialData: EndGameModel.empty(),
        stream: gameClient.endGame,
        builder: (_, endGameSnapshot) => StreamBuilder<GameModel>(
            initialData: GameModel.empty(),
            stream: gameClient.game,
            builder: (_, gameSnapshot) {
              final endGame = EndGameModel.fromNullable(endGameSnapshot.data);
              final game = GameModel.fromNullable(gameSnapshot.data);
              final gameController = GameController(gameClient,
                  _gameSessionController.currentPlayer, game, endGame);

              if (gameController.shouldCreateGame) {
                gameController.create(_settings);
              }

              return DefaultLayout(
                  body: GameView(gameController),
                  bottomActionBar: [
                    if (gameController.isGameOver)
                      BackButtonView(HomePageView(
                          _gameSessionController.client, _userController)),
                    if (!gameController.isGameOver)
                      PassButtonView(gameController),
                  ],
                  bottomActionBarAlignment: gameController.isGameOver
                      ? MainAxisAlignment.start
                      : MainAxisAlignment.end);
            }));
  }
}
