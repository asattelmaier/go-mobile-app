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

  void closeGameSession() {
    _gameSessionController.terminateSession();
  }

  void pass() {
    _gameController.pass();
  }

  bool get isNewGameButtonVisible {
    return !_gameSessionController.isPending;
  }

  bool get isJoinGameButtonVisible {
    return !_gameSessionController.isPending && !_gameController.isPlaying;
  }

  bool get isCancelButtonVisible {
    return _gameSessionController.isPending;
  }

  bool get isPassButtonVisible {
    return _gameController.isPlaying && !_gameController.isGameOver;
  }
}
