import 'package:go_app/game-session/client/game_session_client.dart';
import 'package:go_app/game-session/game_session_model.dart';
import 'package:go_app/game-session/player/session_player_model.dart';
import 'package:rxdart/rxdart.dart';

class GameSessionController {
  final GameSessionClient _gameSessionClient;
  final GameSessionModel _gameSession;
  final SessionPlayerModel _currentPlayer;
  final ValueStream<Map<String, dynamic>> messages;

  GameSessionController(
      this._gameSessionClient, this._gameSession, this._currentPlayer)
      : messages = _gameSessionClient.messages(_gameSession.id)
            .shareValue();

  GameSessionClient get client => _gameSessionClient;

  bool get isPending => _gameSession.isPending;

  bool get isRunning => _gameSession.isRunning;

  SessionPlayerModel get currentPlayer => _currentPlayer;

  String get sessionId => _gameSession.id;

  GameSessionModel get session => _gameSession;

  void updateSession(Object message) {
    _gameSessionClient.updateSession(_gameSession.id, message);
  }

  void terminateSession() {
    _gameSessionClient.terminateSession(_gameSession.id);
  }
}
