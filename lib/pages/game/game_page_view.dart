import 'package:flutter/material.dart' hide Router;

import 'package:go_app/game-session/game_session_controller.dart';
import 'package:go_app/game/client/game_client.dart';
import 'package:go_app/game/end_game/end_game_model.dart';
import 'package:go_app/game/game_controller.dart';
import 'package:go_app/game/game_model.dart';
import 'package:go_app/game/game_view.dart';
import 'package:go_app/game/settings/settings_model.dart';
import 'package:go_app/pages/game/widgets/game_footer.dart';
import 'package:go_app/pages/game/widgets/game_header.dart';
import 'package:go_app/user/user_controller.dart';
import 'package:go_app/widgets/background/home_background.dart';
import 'package:go_app/widgets/layout/page_layout_grid.dart';

class GamePageView extends StatefulWidget {
  final GameSessionController _gameSessionController;
  final SettingsModel _settings;
  final UserController _userController;

  GamePageView(this._gameSessionController, this._userController,
      [this._settings = const SettingsModel.empty()]);

  @override
  State<GamePageView> createState() => _GamePageViewState();
}

class _GamePageViewState extends State<GamePageView> {
  bool _gameCreated = false;
  late final GameClient _gameClient;

  @override
  void initState() {
    super.initState();
    _gameClient = GameClient(widget._gameSessionController);
  }

  @override
  Widget build(BuildContext context) {
    final gameClient = _gameClient;

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
                  widget._gameSessionController.currentPlayer, game, endGame);

              // Only create game once - use flag to prevent re-creation
              if (!_gameCreated && gameController.shouldCreateGame && game.created == 0) {
                _gameCreated = true;
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  gameController.create(widget._settings);
                });
              }
              
              // Reset flag if game was ended and we're starting a new one
              if (game.isGameEnded && _gameCreated) {
                _gameCreated = false;
              }

              return Scaffold(
                body: Stack(
                  children: [
                    HomeBackground(),
                    Positioned.fill(
                      child: SafeArea(
                        child: PageLayoutGrid(
                          topFlex: 1,
                          middleFlex: 10,
                          includeBottomSpacer: false, // Let footer handle it
                          header: GameHeader(
                            gameSessionController: widget._gameSessionController,
                            gameController: gameController,
                          ),
                          content: GameView(gameController),
                          footer: GameFooter(
                            gameController: gameController,
                            gameSessionClient: widget._gameSessionController.client,
                            userController: widget._userController,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }));
  }
}
