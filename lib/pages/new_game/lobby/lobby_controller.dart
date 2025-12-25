import 'dart:async';

import 'package:go_app/game-session/client/game_session_client.dart';
import 'package:go_app/game-session/game_session_model.dart';
import 'package:go_app/game/bot/bot_difficulty.dart';
import 'package:go_app/game/settings/settings_model.dart';
import 'package:go_app/user/user_controller.dart';
import 'package:rxdart/rxdart.dart';

class LobbyController {
  final GameSessionClient _gameSessionClient;
  final UserController _userController;
  final SettingsModel _settings;
  final BotDifficulty? _botDifficulty;

  final _subscriptions = CompositeSubscription();

  // State: Expose current session state
  final _sessionSubject = BehaviorSubject<GameSessionModel>.seeded(GameSessionModel.empty());
  Stream<GameSessionModel> get sessionStream => _sessionSubject.stream;

  // Navigation: Expose a stream that emits ONCE when a valid running session is found
  Stream<GameSessionModel> get navigationStream => _sessionSubject.stream
      .where((session) => session.isRunning)
      .take(1);

  LobbyController(this._gameSessionClient, this._userController, this._settings,
      this._botDifficulty);

  void init() {
    _createSession();
    _setupSessionMonitoring();
  }

  void _setupSessionMonitoring() {
    // Stream 1: WebSocket events (Created)
    final socketStream = _gameSessionClient.created;

    // Stream 2: Polling (Robustness) - Poll every 2s, start after 1s
    final pollingStream = Rx.timer(null, const Duration(seconds: 1))
        .flatMap((_) => Stream.periodic(const Duration(seconds: 2)))
        .asyncMap((_) => _gameSessionClient.getPendingSessions())
        .where((list) => list.isNotEmpty)
        .map((list) => list.first);

    // Merge sources -> Update State
    Rx.merge([socketStream, pollingStream])
        .where((session) => session.id.isNotEmpty)
        .listen(_sessionSubject.add)
        .addTo(_subscriptions);
  }

  Future<void> _createSession() async {
    // Check if we already have a session in our subject (from polling/socket race?)
    if (_sessionSubject.value.id.isNotEmpty) return;

    if (_userController.isUserLoggedIn) {
      _gameSessionClient.createSession(
          _userController.user, _botDifficulty, _settings.boardSize);
    } else {
      final user = await _userController.createGuestUser();
      _gameSessionClient.createSession(
          user, _botDifficulty, _settings.boardSize);
    }
  }

  void cancelSession(String sessionId) {
    if (sessionId.isNotEmpty) {
      _gameSessionClient.terminateSession(sessionId);
    }
  }

  void dispose() {
    _subscriptions.dispose();
    _sessionSubject.close();
  }
}
