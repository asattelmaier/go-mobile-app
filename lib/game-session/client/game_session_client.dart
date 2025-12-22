import 'dart:developer' as developer;

import 'package:go_app/api/http/http_client.dart';
import 'package:go_app/api/http_headers/http_headers_builder.dart';
import 'package:go_app/api/web_socket/web_socket_client.dart';
import 'package:go_app/game/bot/bot_difficulty.dart';
import 'package:go_app/game-session/client/game_session_client_destination.dart';
import 'package:go_app/game-session/client/input/game_session_dto.dart';
import 'package:go_app/game-session/client/output/create_session_dto.dart';
import 'package:go_app/game-session/game_session_model.dart';
import 'package:go_app/user/user_controller.dart';
import 'package:go_app/user/user_model.dart';

class GameSessionClient {
  final WebSocketClient _webSocketClient;
  final HttpClient _httpClient;
  final UserController _userController;
  final _destination = const GameSessionClientDestination();

  const GameSessionClient(
      this._webSocketClient, this._httpClient, this._userController);

  static Future<GameSessionClient> create(WebSocketClient webSocketClient,
      HttpClient httpClient, UserController userController) async {
    final gameSessionClient =
        GameSessionClient(webSocketClient, httpClient, userController);

    await gameSessionClient.connect();

    return gameSessionClient;
  }

  Future<void> connect() {
    if (_userController.isUserLoggedIn) {
      final accessToken = _userController.accessToken;
      final authorizationHeader = HttpHeadersBuilder.token(accessToken).build();

      return _webSocketClient.connect(authorizationHeader);
    }

    return Future(() => null);
  }

  Stream<GameSessionModel> get created {
    // FIXME: Fix Memory Leak in stream subscriptions
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

  void createSession(UserModel user, [BotDifficulty? difficulty, int? boardSize]) {
    if (user.isPresent) {
      final dto = CreateSessionDto(user.id, difficulty?.toDtoValue(), boardSize);
      final json = dto.toJson();
      developer.log("Sending CreateSessionDto: $json");
      _webSocketClient.sendJson(_destination.create, json);
    }
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

  Future<List<GameSessionModel>> getPendingSessions() async {
    try {
      final accessToken = _userController.accessToken;
      final authorizationHeader = HttpHeadersBuilder.token(accessToken).build();
      final response = await _httpClient.get<List<dynamic>>(
          GameSessionClientDestination.pendingSessions, authorizationHeader);

      return response.map((json) => _toGameSession(json)).toList();
    } catch (error) {
      developer.log('Error during pending sessions request: $error',
          error: error);
      return [];
    }
  }

  Stream<Map<String, dynamic>> messages(String gameSessionId) {
    return _webSocketClient.subscribe(_destination.updated(gameSessionId));
  }

  static GameSessionModel _toGameSession(Map<String, dynamic> json) {
    return GameSessionModel.fromDto(GameSessionDto.fromJson(json));
  }

  Map<String, dynamic> Function(Map<String, dynamic>) _logJson(String context) {
    return (Map<String, dynamic> json) {
      developer.log('$context: ${json.toString()}');
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
