import 'package:go_app/api/web_socket/web_socket_client.dart';
import 'package:go_app/game-session/client/game_session_client_destination.dart';
import 'package:go_app/game-session/client/input/game_session_dto.dart';
import 'package:go_app/game-session/game_session_model.dart';
import 'package:rxdart/rxdart.dart';

class GameSessionClient {
  final WebSocketClient _client;
  final BehaviorSubject<GameSessionModel> _gameSession;
  final GameSessionClientDestination _destination;

  factory GameSessionClient(WebSocketClient webSocketClient) {
    // ignore: close_sinks
    BehaviorSubject<GameSessionModel> gameSession = BehaviorSubject();
    final destination = GameSessionClientDestination(gameSession);
    final createdDestination = GameSessionClientDestination.created;
    final joinedDestination = GameSessionClientDestination.joined;
    final playerJoinedDestination = GameSessionClientDestination.playerJoined;

    gameSession.mergeWith([
      webSocketClient.subscribe(createdDestination).map(_toGameSession),
      webSocketClient.subscribe(joinedDestination).map(_toGameSession),
      webSocketClient.subscribe(playerJoinedDestination).map(_toGameSession)
    ]);

    return GameSessionClient._(webSocketClient, gameSession, destination);
  }

  void create() {
    _client.send(_destination.create);
  }

  void join(String gameSessionId) {
    _client.send(_destination.join);
  }

  void update(Object message) {
    _client.sendJson(_destination.update, message);
  }

  Stream<Map<String, dynamic>> get messages {
    return _client.subscribe(_destination.updated);
  }

  void close() {
    _client.close();
    _gameSession.close();
  }

  static GameSessionModel _toGameSession(Map<String, dynamic> json) {
    return GameSessionModel.fromDto(GameSessionDto.fromJson(json));
  }

  GameSessionClient._(this._client, this._gameSession, this._destination);
}
