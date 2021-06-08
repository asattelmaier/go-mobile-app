import 'dart:async';

import 'package:go_app/game-session/client/game_session_client.dart';
import 'package:go_app/game-session/game_session_model.dart';
import 'package:rxdart/rxdart.dart';

class GameSessionController {
  final _gameSession = BehaviorSubject<GameSessionModel>();
  final _messages = BehaviorSubject<Map<String, dynamic>>();
  final _playerJoined = BehaviorSubject();
  final GameSessionClient _gameSessionClient;

  factory GameSessionController(GameSessionClient gameSessionClient) {
    final controller = GameSessionController._(gameSessionClient);

    gameSessionClient.created.listen(controller._onGameSessionCreated);

    return controller;
  }

  Stream get updateStream => _gameSession.stream;

  Stream get playerJoined => _playerJoined.stream;

  String get gameSessionId {
    if (_gameSession.hasValue) {
      return _gameSession.value.id;
    }

    return GameSessionModel.empty().id;
  }

  ValueStream<Map<String, dynamic>> get messages {
    return _messages.shareValue();
  }

  void join(String gameSessionId) {
    _gameSessionClient.join(gameSessionId);
  }

  void update(Object message) {
    _gameSessionClient.update(gameSessionId, message);
  }

  void createSession() {
    _gameSessionClient.create();
  }

  void close() {
    _gameSessionClient.close();
    _playerJoined.close();
  }

  GameSessionController._(this._gameSessionClient);

  void _onGameSessionCreated(GameSessionModel gameSession) {
    _messages.addStream(_gameSessionClient.messages(gameSession.id));
    _gameSession.add(gameSession);
    _gameSessionClient.playerJoined(gameSession.id).listen(_onPlayerJoined);
  }

  void _onPlayerJoined(GameSessionModel gameSession) {
    _playerJoined.add(true);
    _gameSession.add(gameSession);
  }
}
