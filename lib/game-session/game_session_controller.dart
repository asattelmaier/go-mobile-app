import 'package:session_server_client/api.dart';
import 'package:go_app/game-session/client/game_session_client.dart';
import 'package:go_app/game-session/game_session_model.dart';
import 'package:go_app/game-session/player/session_player_model.dart';
import 'package:rxdart/rxdart.dart';

class GameSessionController {
  final GameSessionClient _gameSessionClient;
  final GameSessionModel _gameSession;
  final SessionPlayerModel _currentPlayer;
  final ValueStream<GameDto> gameUpdates;
  final ValueStream<EndGameDto> gameEnded;

  GameSessionController(
      this._gameSessionClient, this._gameSession, this._currentPlayer)
      : gameUpdates = _gameSessionClient.gameUpdates(_gameSession.id).shareValue(),
        gameEnded = _gameSessionClient.gameEnded(_gameSession.id).shareValue();

  bool get isPending => _gameSession.isPending;

  bool get isRunning => _gameSession.isRunning;

  SessionPlayerModel get currentPlayer => _currentPlayer;

  String get sessionId => _gameSession.id;

  GameSessionModel get session => _gameSession;

  void updateSession(Object message) {
    _gameSessionClient.updateSession(_gameSession.id, message);
  }

  void sendMove(DeviceMove move) {
    _gameSessionClient.sendMove(_gameSession.id, move);
  }

  void terminateSession() {
    _gameSessionClient.terminateSession(_gameSession.id);
  }

  Future<void> dispose() {
    return _gameSessionClient.dispose(_gameSession.id);
  }
}
