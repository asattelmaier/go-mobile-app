import 'dart:async';

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
  SessionPlayerModel
])
void main() {
  group('updateStream', () {
    test('updates on game creation', () async {
      final client = MockGameSessionClient();
      final gameCreatedStream = MockStream<GameSessionModel>();
      final gameSession = MockGameSessionModel();
      final gameSessionId = "some-id";

      when(client.created).thenAnswer((_) => gameCreatedStream);
      when(client.joined).thenAnswer((_) => Stream.empty());
      when(gameSession.id).thenReturn(gameSessionId);
      when(gameSession.players).thenReturn([MockSessionPlayerModel()]);
      when(client.messages(gameSessionId)).thenAnswer((_) => Stream.empty());
      when(client.playerJoined(gameSessionId))
          .thenAnswer((_) => Stream.empty());
      when(client.terminated(gameSessionId)).thenAnswer((_) => Stream.empty());
      when(gameCreatedStream.listen(any)).thenAnswer((invocation) {
        final listener = invocation.positionalArguments.single;
        listener(gameSession);
        return MockStreamSubscription<GameSessionModel>();
      });
      final gameSessionController = GameSessionController(client);
      final updateStream = await gameSessionController.updateStream.first;

      expect(updateStream, gameSession);
    });

    test('updates on player joined', () async {
      final client = MockGameSessionClient();
      final gameCreatedStream = MockStream<GameSessionModel>();
      final playerJoinedStream = MockStream<GameSessionModel>();
      final createdGameSession = MockGameSessionModel();
      final playerJoinedGameSession = MockGameSessionModel();
      final gameSessionId = "some-id";

      when(client.created).thenAnswer((_) => gameCreatedStream);
      when(client.joined).thenAnswer((_) => Stream.empty());
      when(createdGameSession.id).thenReturn(gameSessionId);
      when(createdGameSession.players).thenReturn([MockSessionPlayerModel()]);
      when(client.messages(gameSessionId)).thenAnswer((_) => Stream.empty());
      when(client.playerJoined(gameSessionId))
          .thenAnswer((_) => playerJoinedStream);
      when(client.terminated(gameSessionId)).thenAnswer((_) => Stream.empty());
      when(gameCreatedStream.listen(any)).thenAnswer((invocation) {
        final listener = invocation.positionalArguments.single;
        listener(createdGameSession);
        return MockStreamSubscription<GameSessionModel>();
      });
      when(playerJoinedStream.listen(any)).thenAnswer((invocation) {
        final listener = invocation.positionalArguments.single;
        listener(playerJoinedGameSession);
        return MockStreamSubscription<GameSessionModel>();
      });
      final gameSessionController = GameSessionController(client);
      final updateStream = await gameSessionController.updateStream
          .firstWhere((gameSession) => gameSession == playerJoinedGameSession);

      expect(updateStream, playerJoinedGameSession);
    });
  });
}
