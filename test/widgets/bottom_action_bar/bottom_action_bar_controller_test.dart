import 'package:flutter_test/flutter_test.dart';
import 'package:go_app/game-session/game_session_controller.dart';
import 'package:go_app/game/game_controller.dart';
import 'package:go_app/widgets/bottom_action_bar/bottom_action_bar_controller.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'bottom_action_bar_controller_test.mocks.dart';

@GenerateMocks([GameSessionController, GameController])
void main() {
  group('createGameSession', () {
    test('creates a game session', () {
      final gameSessionController = MockGameSessionController();
      final gameController = MockGameController();
      final bottomActionBarController =
          BottomActionBarController(gameSessionController, gameController);

      when(gameSessionController.createSession()).thenReturn(null);
      bottomActionBarController.createGameSession();

      verify(gameSessionController.createSession()).called(1);
    });
  });

  group('closeGameSession', () {
    test('closes a game session', () {
      final gameSessionController = MockGameSessionController();
      final gameController = MockGameController();
      final bottomActionBarController = BottomActionBarController(gameSessionController, gameController);

      when(gameSessionController.terminateSession()).thenReturn(null);
      bottomActionBarController.closeGameSession();

      verify(gameSessionController.terminateSession()).called(1);
    });
  });

  group('pass', () {
    test('passes the game', () {
      final gameSessionController = MockGameSessionController();
      final gameController = MockGameController();
      final bottomActionBarController =
          BottomActionBarController(gameSessionController, gameController);

      when(gameController.pass()).thenReturn(null);
      bottomActionBarController.pass();

      verify(gameController.pass()).called(1);
    });
  });

  group('isJoinGameButtonVisible', () {
    test('is visible if game is not playing and session is not pending', () {
      final gameSessionController = MockGameSessionController();
      final gameController = MockGameController();
      final bottomActionBarController =
          BottomActionBarController(gameSessionController, gameController);

      when(gameController.isPlaying).thenReturn(false);
      when(gameSessionController.isPending).thenReturn(false);
      final isJoinGameButtonVisible =
          bottomActionBarController.isJoinGameButtonVisible;

      expect(isJoinGameButtonVisible, true);
    });

    test('is not visible if game is playing', () {
      final gameSessionController = MockGameSessionController();
      final gameController = MockGameController();
      final bottomActionBarController =
          BottomActionBarController(gameSessionController, gameController);

      when(gameController.isPlaying).thenReturn(true);
      when(gameSessionController.isPending).thenReturn(false);
      final isJoinGameButtonVisible =
          bottomActionBarController.isJoinGameButtonVisible;

      expect(isJoinGameButtonVisible, false);
    });

    test('is not visible if game session is pending', () {
      final gameSessionController = MockGameSessionController();
      final gameController = MockGameController();
      final bottomActionBarController =
          BottomActionBarController(gameSessionController, gameController);

      when(gameController.isPlaying).thenReturn(false);
      when(gameSessionController.isPending).thenReturn(true);
      final isJoinGameButtonVisible =
          bottomActionBarController.isJoinGameButtonVisible;

      expect(isJoinGameButtonVisible, false);
    });
  });

  group('isPassButtonVisible', () {
    test('is visible if game is playing but not over', () {
      final gameSessionController = MockGameSessionController();
      final gameController = MockGameController();
      final bottomActionBarController =
          BottomActionBarController(gameSessionController, gameController);

      when(gameController.isPlaying).thenReturn(true);
      when(gameController.isGameOver).thenReturn(false);
      final isPassButtonVisible = bottomActionBarController.isPassButtonVisible;

      expect(isPassButtonVisible, true);
    });

    test('is not visible if game is not playing', () {
      final gameSessionController = MockGameSessionController();
      final gameController = MockGameController();
      final bottomActionBarController =
          BottomActionBarController(gameSessionController, gameController);

      when(gameController.isPlaying).thenReturn(false);
      when(gameController.isGameOver).thenReturn(false);
      final isPassButtonVisible = bottomActionBarController.isPassButtonVisible;

      expect(isPassButtonVisible, false);
    });

    test('is not visible if game is over', () {
      final gameSessionController = MockGameSessionController();
      final gameController = MockGameController();
      final bottomActionBarController =
          BottomActionBarController(gameSessionController, gameController);

      when(gameController.isPlaying).thenReturn(true);
      when(gameController.isGameOver).thenReturn(true);
      final isPassButtonVisible = bottomActionBarController.isPassButtonVisible;

      expect(isPassButtonVisible, false);
    });
  });

  group('isNewGameButtonVisible', () {
    test('is visible if the game session is not pending', () {
      final gameSessionController = MockGameSessionController();
      final gameController = MockGameController();
      final bottomActionBarController =
          BottomActionBarController(gameSessionController, gameController);

      when(gameSessionController.isPending).thenReturn(false);
      final isNewGameButtonVisible =
          bottomActionBarController.isNewGameButtonVisible;

      expect(isNewGameButtonVisible, true);
    });

    test('is not visible if the game session is pending', () {
      final gameSessionController = MockGameSessionController();
      final gameController = MockGameController();
      final bottomActionBarController =
          BottomActionBarController(gameSessionController, gameController);

      when(gameSessionController.isPending).thenReturn(true);
      final isNewGameButtonVisible =
          bottomActionBarController.isNewGameButtonVisible;

      expect(isNewGameButtonVisible, false);
    });
  });

  group('isCancelButtonVisible', () {
    test('is visible if the game session is pending', () {
      final gameSessionController = MockGameSessionController();
      final gameController = MockGameController();
      final bottomActionBarController =
          BottomActionBarController(gameSessionController, gameController);

      when(gameSessionController.isPending).thenReturn(true);
      final isCancelButtonVisible =
          bottomActionBarController.isCancelButtonVisible;

      expect(isCancelButtonVisible, true);
    });

    test('is not visible if the game session is not pending', () {
      final gameSessionController = MockGameSessionController();
      final gameController = MockGameController();
      final bottomActionBarController =
          BottomActionBarController(gameSessionController, gameController);

      when(gameSessionController.isPending).thenReturn(false);
      final isCancelButtonVisible =
          bottomActionBarController.isCancelButtonVisible;

      expect(isCancelButtonVisible, false);
    });
  });
}
