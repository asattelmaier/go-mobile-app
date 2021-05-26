import 'package:flutter_test/flutter_test.dart';
import 'package:go_app/game/client/game_client.dart';
import 'package:go_app/game/end_game/end_game_model.dart';
import 'package:go_app/game/game_controller.dart';
import 'package:go_app/game/board/intersection/location/location_model.dart';
import 'package:go_app/game/game_model.dart';
import 'package:go_app/game/settings/settings_model.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'game_controller_test.mocks.dart';

@GenerateMocks([GameClient, GameModel, EndGameModel, LocationModel])
void main() {
  group('play', () {
    test('plays if the game is not over', () async {
      final client = MockGameClient();
      final game = MockGameModel();
      final endGame = MockEndGameModel();
      final location = MockLocationModel();

      when(client.play(location, game)).thenReturn(null);
      when(game.created).thenReturn(2);
      when(endGame.created).thenReturn(1);
      GameController(client, game, endGame).play(location);

      verify(client.play(location, game)).called(1);
    });

    test('play is only possible if the game is not over', () {
      final client = MockGameClient();
      final game = MockGameModel();
      final endGame = MockEndGameModel();
      final location = MockLocationModel();
      final controller = GameController(client, game, endGame);

      when(game.created).thenReturn(1);
      when(endGame.created).thenReturn(2);
      controller.play(location);

      verifyNever(client.play(location, game));
    });
  });

  group('isGameOver', () {
    test('game is over if the end game is created after the game', () {
      final client = MockGameClient();
      final game = MockGameModel();
      final endGame = MockEndGameModel();
      final controller = GameController(client, game, endGame);

      when(game.created).thenReturn(1);
      when(endGame.created).thenReturn(2);
      final isGameOver = controller.isGameOver;

      expect(isGameOver, true);
    });

    test('game is running if the game is created after the end game', () {
      final client = MockGameClient();
      final game = MockGameModel();
      final endGame = MockEndGameModel();
      final controller = GameController(client, game, endGame);

      when(game.created).thenReturn(2);
      when(endGame.created).thenReturn(1);
      final isGameOver = controller.isGameOver;

      expect(isGameOver, false);
    });
  });

  group('create', () {
    test('creates a game with provided size', () {
      final client = MockGameClient();
      final game = MockGameModel();
      final endGame = MockEndGameModel();
      final controller = GameController(client, game, endGame);

      when(client.create(any)).thenReturn(null);
      controller.create(5, false);

      verify(client.create(argThat(isA<SettingsModel>()))).called(1);
    });
  });

  group('pass', () {
    test('passes the game with the current game', () {
      final client = MockGameClient();
      final game = MockGameModel();
      final endGame = MockEndGameModel();

      when(client.pass(any)).thenReturn(null);
      GameController(client, game, endGame).pass();

      verify(client.pass(game)).called(1);
    });
  });
}
