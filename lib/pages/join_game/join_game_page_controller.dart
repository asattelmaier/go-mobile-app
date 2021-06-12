import 'package:go_app/game-session/game_session_controller.dart';

class JoinGamePageController {
  final GameSessionController _gameSessionController;

  const JoinGamePageController(this._gameSessionController);

  void join(String gameSessionId) {
    _gameSessionController.joinSession(gameSessionId);
  }
}
