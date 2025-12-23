import 'dart:developer' as developer;

import 'package:go_app/api/http_headers/http_headers_builder.dart';
import 'package:go_app/api/web_socket/web_socket_client.dart';
import 'package:go_app/game/bot/bot_difficulty.dart';
import 'package:go_app/game-session/client/game_session_client_destination.dart';
import 'package:go_app/game-session/game_session_model.dart';
import 'package:go_app/user/user_controller.dart';
import 'package:go_app/user/user_model.dart';
import 'package:session_server_client/api.dart';
import 'package:rxdart/rxdart.dart';

// TODO: Client should only be called by Controller
class GameSessionClient {
  final WebSocketClient _webSocketClient;
  final ApiClient _apiClient;
  final UserController _userController;
  final _destination = const GameSessionClientDestination();

  const GameSessionClient(
      this._webSocketClient, this._apiClient, this._userController);

  static Future<GameSessionClient> create(WebSocketClient webSocketClient,
      ApiClient apiClient, UserController userController) async {
    final gameSessionClient =
        GameSessionClient(webSocketClient, apiClient, userController);

    await gameSessionClient.connect();

    return gameSessionClient;
  }

  Future<void> connect() {
    if (_userController.isUserLoggedIn) {
      final accessToken = _userController.accessToken;
      // WebSocketClient still needs manual header for STOMP connect
      final authorizationHeader = HttpHeadersBuilder.token(accessToken).build();

      return _webSocketClient.connect(authorizationHeader);
    }

    return Future(() => null);
  }

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

  Stream<GameDto> gameUpdates(String gameSessionId) {
    return _webSocketClient
        .subscribe(_destination.updated(gameSessionId))
        .doOnListen(() => _requestGameState(gameSessionId))
        .map(_logJson("updated"))
        .map((json) => GameDto.fromJson(json)!);
  }

  Stream<EndGameDto> gameEnded(String gameSessionId) {
    return _webSocketClient
        .subscribe(_destination.endgame(gameSessionId))
        .map(_logJson("endgame"))
        .map((json) => EndGameDto.fromJson(json)!);
  }

  void createSession(
      UserModel user, [BotDifficulty? difficulty, int? boardSize]) {
    if (!user.isPresent) return;

    _webSocketClient.sendJson(
        _destination.create,
        CreateSessionDto(
          playerId: user.id,
          difficulty: difficulty != null
              ? CreateSessionDtoDifficultyEnum.fromJson(difficulty.toDtoValue())
              : null,
          boardSize: boardSize,
        ).toJson());
  }

  void joinSession(String gameSessionId) {
    _webSocketClient.send(_destination.join(gameSessionId));
  }

  void updateSession(String gameSessionId, Object message) {
    _webSocketClient.sendJson(_destination.update(gameSessionId), message);
  }

  void _requestGameState(String gameSessionId) {
    updateSession(gameSessionId, {
      // TODO: Create a DTO for this command in the future (currently missing in backend spec)
      "command": {"name": "CREATE"}
    });
  }

  void sendMove(String gameSessionId, DeviceMove move) {
    updateSession(gameSessionId, move.toJson());
  }

  void terminateSession(String gameSessionId) {
    _webSocketClient.send(_destination.terminate(gameSessionId));
  }

  Future<List<GameSessionModel>> getPendingSessions() async {
    try {
      final sessionApi = SessionRestControllerApi(_apiClient);
      final response = await sessionApi.getPendingSessions();

      if (response == null) return [];

      return response.map((dto) => GameSessionModel.fromDto(dto)).toList();
    } catch (error) {
      developer.log('Error during pending sessions request: $error',
          error: error);
      return [];
    }
  }

  static GameSessionModel _toGameSession(Map<String, dynamic> json) {
    // TODO: Unify naming: SessionDto vs GameSessionModel
    return GameSessionModel.fromDto(SessionDto.fromJson(json)!);
  }

  Map<String, dynamic> Function(Map<String, dynamic>) _logJson(String context) {
    return (Map<String, dynamic> json) {
      developer.log('$context: $json', name: 'GameSessionClient');
      return json;
    };
  }

  Future<void> dispose(String gameSessionId) {
    return _webSocketClient.dispose([
      _destination.terminate(gameSessionId),
      _destination.terminated(gameSessionId),
      _destination.update(gameSessionId),
      _destination.updated(gameSessionId),
      _destination.endgame(gameSessionId),
      _destination.join(gameSessionId),
      _destination.playerJoined(gameSessionId)
    ]);
  }
}
