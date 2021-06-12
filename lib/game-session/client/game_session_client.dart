import 'dart:developer';

import 'package:go_app/api/web_socket/web_socket_client.dart';
import 'package:go_app/game-session/client/game_session_client_destination.dart';
import 'package:go_app/game-session/client/input/game_session_dto.dart';
import 'package:go_app/game-session/game_session_model.dart';

class GameSessionClient {
  final WebSocketClient _webSocketClient;
  final _destination = const GameSessionClientDestination();

  const GameSessionClient(this._webSocketClient);

  Stream<GameSessionModel> get created {
    return _webSocketClient
        .subscribe(GameSessionClientDestination.created)
        .map(_logJson("created"))
        .map(_toGameSession);
  }

  Stream<GameSessionModel> get joined {
    return _webSocketClient
        .subscribe(GameSessionClientDestination.joined)
        .map(_logJson("joined"))
        .map(_toGameSession);
  }

  Stream<GameSessionModel> terminated(String gameSessionId) {
    return _webSocketClient
        .subscribe(_destination.terminated(gameSessionId))
        .map(_logJson("terminated"))
        .map(_toGameSession);
  }

  Stream<GameSessionModel> playerJoined(String gameSessionId) {
    return _webSocketClient
        .subscribe(_destination.playerJoined(gameSessionId))
        .map(_logJson("playerJoined"))
        .map(_toGameSession);
  }

  void createSession() {
    _webSocketClient.send(_destination.create);
  }

  void joinSession(String gameSessionId) {
    _webSocketClient.send(_destination.join(gameSessionId));
  }

  void updateSession(String gameSessionId, Object message) {
    _webSocketClient.sendJson(_destination.update(gameSessionId), message);
  }

  void terminateSession(String gameSessionId) {
    _webSocketClient.send(_destination.terminate(gameSessionId));
  }

  Stream<Map<String, dynamic>> messages(String gameSessionId) {
    return _webSocketClient
        .subscribe(_destination.updated(gameSessionId))
        .map(_logJson("messages"));
  }

  static GameSessionModel _toGameSession(Map<String, dynamic> json) {
    return GameSessionModel.fromDto(GameSessionDto.fromJson(json));
  }

  Map<String, dynamic> Function(Map<String, dynamic>) _logJson(String context) {
    return (Map<String, dynamic> json) {
      log('$context: ${json.toString()}');
      return json;
    };
  }

  Future<void> dispose(String gameSessionId) {
    return _webSocketClient.dispose([
      _destination.terminate(gameSessionId),
      _destination.terminated(gameSessionId),
      _destination.update(gameSessionId),
      _destination.updated(gameSessionId),
      _destination.join(gameSessionId),
      _destination.playerJoined(gameSessionId)
    ]);
  }
}
