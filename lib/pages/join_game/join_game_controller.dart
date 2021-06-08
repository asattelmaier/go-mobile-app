import 'package:go_app/game-session/game_session_controller.dart';

class JoinGameController {
  final GameSessionController _gameSessionController;

  const JoinGameController(this._gameSessionController);

  void join(String gameSessionId) {
    _gameSessionController.join(gameSessionId);
  }
}
