import 'package:flutter_test/flutter_test.dart';
import 'package:go_app/game-session/game_session_controller.dart';
import 'package:go_app/pages/join_game/join_game_controller.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'join_game_controller_test.mocks.dart';

@GenerateMocks([GameSessionController])
void main() {
  group('join', () {
    test('joins a game session', () {
      final gameSessionController = MockGameSessionController();
      final joinGameController = JoinGameController(gameSessionController);
      final gameSessionId = "some-id";

      when(gameSessionController.joinSession(gameSessionId)).thenReturn(null);
      joinGameController.join(gameSessionId);

      verify(gameSessionController.joinSession(gameSessionId)).called(1);
    });
  });
}
