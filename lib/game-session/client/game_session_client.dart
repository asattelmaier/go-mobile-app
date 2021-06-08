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
        .map(_toGameSession);
  }

  Stream<GameSessionModel> get joined {
    return _webSocketClient
        .subscribe(GameSessionClientDestination.joined)
        .map(_toGameSession);
  }

  Stream<GameSessionModel> playerJoined(String gameSessionId) {
    return _webSocketClient
        .subscribe(_destination.playerJoined(gameSessionId))
        .map(_toGameSession);
  }

  void create() {
    _webSocketClient.send(_destination.create);
  }

  void join(String gameSessionId) {
    _webSocketClient.send(_destination.join(gameSessionId));
  }

  void update(String gameSessionId, Object message) {
    _webSocketClient.sendJson(_destination.update(gameSessionId), message);
  }

  Stream<Map<String, dynamic>> messages(String gameSessionId) {
    return _webSocketClient.subscribe(_destination.updated(gameSessionId));
  }

  void close() {
    _webSocketClient.close();
  }

  static GameSessionModel _toGameSession(Map<String, dynamic> json) {
    return GameSessionModel.fromDto(GameSessionDto.fromJson(json));
  }
}
