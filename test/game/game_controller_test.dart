import 'package:flutter_test/flutter_test.dart';
import 'package:go_app/game/client/game_client.dart';
import 'package:go_app/game/end_game/end_game_model.dart';
import 'package:go_app/game/game_controller.dart';
import 'package:go_app/game/board/intersection/location/location_model.dart';
import 'package:go_app/game/game_model.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'game_controller_test.mocks.dart';

@GenerateMocks([GameClient, GameModel, EndGameModel, LocationModel])
void main() {
  group('play', () {
    test('plays with a location and the current game', () async {
      final client = MockGameClient();
      final game = MockGameModel();
      final endGame = MockEndGameModel();
      final location = MockLocationModel();

      when(client.play(any, any)).thenReturn(null);
      GameController(client, game, endGame).play(location);

      verify(client.play(location, game)).called(1);
    });
  });

  group('create', () {
    test('creates a game with provided size', () {
      final client = MockGameClient();
      final game = MockGameModel();
      final endGame = MockEndGameModel();

      when(client.create(any)).thenReturn(null);
      GameController(client, game, endGame).create(5);

      verify(client.create(5)).called(1);
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
