import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:go_app/game-session/client/game_session_client.dart';
import 'package:go_app/game-session/game_session_controller.dart';
import 'package:go_app/game-session/game_session_model.dart';
import 'package:go_app/game-session/player/session_player_model.dart';
import 'package:go_app/user/user_model.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'game_session_controller_test.mocks.dart';

@GenerateMocks([
  GameSessionClient,
  Stream,
  StreamSubscription,
  GameSessionModel,
  SessionPlayerModel,
  UserModel,
])
void main() {
  group('joinSession', () {
    test('joins session', () async {
      final client = MockGameSessionClient();
      final gameSession = MockGameSessionModel();
      final currentPlayer = MockSessionPlayerModel();
      final controller = GameSessionController(client, gameSession, currentPlayer);

      controller.joinSession("some-id");

      verify(client.joinSession("some-id")).called(1);
    });
  });

  group('updateSession', () {
    test('updates session', () async {
      final client = MockGameSessionClient();
      final gameSession = MockGameSessionModel();
      final currentPlayer = MockSessionPlayerModel();
      final controller = GameSessionController(client, gameSession, currentPlayer);

      when(gameSession.id).thenReturn("some-id");
      controller.updateSession({"some": "message"});

      verify(client.updateSession("some-id", {"some": "message"})).called(1);
    });
  });

  group('createSession', () {
    test('creates game session', () async {
      final user = MockUserModel();
      final client = MockGameSessionClient();
      final gameSession = MockGameSessionModel();
      final currentPlayer = MockSessionPlayerModel();
      final controller = GameSessionController(client, gameSession, currentPlayer);

      controller.createSession(user);

      verify(client.createSession(user)).called(1);
    });
  });

  group('terminateSession', () {
    test('terminates session', () async {
      final client = MockGameSessionClient();
      final gameSession = MockGameSessionModel();
      final currentPlayer = MockSessionPlayerModel();
      final controller = GameSessionController(client, gameSession, currentPlayer);

      when(gameSession.id).thenReturn("some-id");
      controller.terminateSession();

      verify(client.terminateSession("some-id")).called(1);
    });
  });
}
