import 'dart:async';
import 'package:async/async.dart';

import 'package:go_app/game-session/client/game_session_client.dart';
import 'package:go_app/game-session/game_session_model.dart';
import 'package:rxdart/rxdart.dart';

class GameSessionController {
  final _gameSessionSubject = BehaviorSubject<GameSessionModel>();
  final _messages = BehaviorSubject<Map<String, dynamic>>();
  final _playerJoined = BehaviorSubject();
  final GameSessionClient _gameSessionClient;

  factory GameSessionController(GameSessionClient gameSessionClient) {
    final controller = GameSessionController._(gameSessionClient);

    gameSessionClient.created.listen(controller._onGameSessionCreated);

    return controller;
  }

  Stream get updateStream =>
      StreamGroup.merge([_messages, _gameSessionSubject.stream]);

  Stream get playerJoined => _playerJoined.stream;

  bool get isPending => _gameSession.isPending;

  GameSessionModel get _gameSession {
    if (_gameSessionSubject.hasValue) {
      return _gameSessionSubject.value;
    }

    return GameSessionModel.empty();
  }

  ValueStream<Map<String, dynamic>> get messages {
    return _messages.shareValue();
  }

  void join(String gameSessionId) {
    _gameSessionClient.join(gameSessionId);
  }

  void update(Object message) {
    _gameSessionClient.update(_gameSession.id, message);
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
    _gameSessionSubject.add(gameSession);
    _gameSessionClient.playerJoined(gameSession.id).listen(_onPlayerJoined);
  }

  void _onPlayerJoined(GameSessionModel gameSession) {
    _playerJoined.add(true);
    _gameSessionSubject.add(gameSession);
  }
}
