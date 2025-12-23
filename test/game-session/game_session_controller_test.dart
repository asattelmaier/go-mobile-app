import 'dart:async';
import 'package:rxdart/rxdart.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:go_app/game-session/client/game_session_client.dart';
import 'package:go_app/game-session/game_session_controller.dart';
import 'package:go_app/game-session/game_session_model.dart';
import 'package:go_app/game-session/player/session_player_model.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'game_session_controller_test.mocks.dart';

@GenerateMocks([
  GameSessionClient,
  Stream,
  StreamSubscription,
  GameSessionModel,
  SessionPlayerModel,
])
void main() {


  group('terminateSession', () {
    test('terminates session', () async {
      final client = MockGameSessionClient();
      final gameSession = MockGameSessionModel();
      final currentPlayer = MockSessionPlayerModel();
      when(gameSession.id).thenReturn("some-id");
      when(client.messages("some-id")).thenAnswer((_) => Stream<Map<String, dynamic>>.value(<String, dynamic>{}).shareValueSeeded(<String, dynamic>{}));
      final controller = GameSessionController(client, gameSession, currentPlayer);

      when(gameSession.id).thenReturn("some-id");
      controller.terminateSession();

      verify(client.terminateSession("some-id")).called(1);
    });
  });
}
