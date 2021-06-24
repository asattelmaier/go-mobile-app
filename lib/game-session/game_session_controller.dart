import 'dart:async';
import 'package:async/async.dart';

import 'package:go_app/game-session/client/game_session_client.dart';
import 'package:go_app/game-session/game_session_model.dart';
import 'package:go_app/game-session/player/session_player_model.dart';
import 'package:rxdart/rxdart.dart';

class GameSessionController {
  final _gameSessionSubject = BehaviorSubject<GameSessionModel>();
  final _messages = BehaviorSubject<Map<String, dynamic>>();
  final _playerJoined = StreamController.broadcast();
  final _joined = StreamController.broadcast();
  final GameSessionClient _gameSessionClient;
  final List<StreamSubscription> _subscriptions = [];
  SessionPlayerModel _currentPlayer = SessionPlayerModel.empty();

  factory GameSessionController(GameSessionClient gameSessionClient) {
    final controller = GameSessionController._(gameSessionClient);

    gameSessionClient.created.listen(controller._onGameSessionCreated);
    gameSessionClient.joined.listen(controller._onJoined);

    return controller;
  }

  Stream get updateStream =>
      StreamGroup.merge([_messages, _gameSessionSubject.stream]);

  bool get isPending => _gameSession.isPending;

  bool get isRunning => _gameSession.isRunning;

  SessionPlayerModel get currentPlayer => _currentPlayer;

  String get sessionId => _gameSession.id;

  void onPlayerJoined(void Function(dynamic) listener) {
    _subscriptions.add(_playerJoined.stream.listen(listener));
  }

  void onJoined(void Function(dynamic) listener) {
    _subscriptions.add(_joined.stream.listen(listener));
  }

  GameSessionModel get _gameSession {
    if (_gameSessionSubject.hasValue) {
      return _gameSessionSubject.value;
    }

    return GameSessionModel.empty();
  }

  ValueStream<Map<String, dynamic>> get messages {
    return _messages.shareValue();
  }

  void joinSession(String gameSessionId) {
    _gameSessionClient.joinSession(gameSessionId);
  }

  void updateSession(Object message) {
    _gameSessionClient.updateSession(_gameSession.id, message);
  }

  void createSession() {
    _gameSessionClient.createSession();
  }

  void terminateSession() async {
    _dispose();
    _gameSessionClient.terminateSession(_gameSession.id);
  }

  GameSessionController._(this._gameSessionClient);

  void _onGameSessionCreated(GameSessionModel gameSession) async {
    _currentPlayer = gameSession.players.first;
    _setupGameSession(gameSession);
    _gameSessionClient.playerJoined(gameSession.id).listen(_onPlayerJoined);
  }

  void _onJoined(GameSessionModel gameSession) async {
    _currentPlayer = gameSession.players.last;
    _joined.add(gameSession);
    _setupGameSession(gameSession);
  }

  void _setupGameSession(GameSessionModel gameSession) {
    final id = gameSession.id;

    _gameSessionClient.messages(id).listen((message) => _messages.add(message));
    _gameSessionSubject.add(gameSession);
    _gameSessionClient.terminated(id).listen(_onTermination);
  }

  void _onPlayerJoined(GameSessionModel gameSession) {
    _playerJoined.add(gameSession);
    _gameSessionSubject.add(gameSession);
  }

  void _onTermination(GameSessionModel gameSession) async {
    await _gameSessionClient.dispose(gameSession.id);
    _gameSessionSubject.add(gameSession);
  }

  _dispose() async {
    await Future.wait(_subscriptions.map((subscription) {
      return subscription.cancel();
    }));
    _subscriptions.clear();
  }
}
