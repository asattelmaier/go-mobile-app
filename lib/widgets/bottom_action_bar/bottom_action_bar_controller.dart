import 'package:go_app/game-session/game_session_controller.dart';
import 'package:go_app/game/game_controller.dart';

class BottomActionBarController {
  final GameSessionController _gameSessionController;
  final GameController _gameController;

  const BottomActionBarController(
      this._gameSessionController, this._gameController);

  GameSessionController get gameSessionController => _gameSessionController;

  void createGameSession() {
    _gameSessionController.createSession();
  }

  void pass() {
    _gameController.pass();
  }

  bool get isPassButtonVisible {
    return _gameController.isPlaying && !_gameController.isGameOver;
  }
}
