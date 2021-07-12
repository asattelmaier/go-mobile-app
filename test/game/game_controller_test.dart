import 'package:flutter_test/flutter_test.dart';
import 'package:go_app/game-session/player/session_player_model.dart'
    as GameSession;
import 'package:go_app/game/board/intersection/location/location_model.dart';
import 'package:go_app/game/client/game_client.dart';
import 'package:go_app/game/end_game/end_game_model.dart';
import 'package:go_app/game/game_controller.dart';
import 'package:go_app/game/game_model.dart';
import 'package:go_app/game/player/player_color.dart';
import 'package:go_app/game/player/player_model.dart';
import 'package:go_app/game/settings/settings_model.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rxdart/rxdart.dart';

import 'game_controller_test.mocks.dart';

@GenerateMocks([
  GameClient,
  GameModel,
  EndGameModel,
  LocationModel,
  PlayerModel,
  SettingsModel
], customMocks: [
  MockSpec<GameSession.SessionPlayerModel>(as: #MockGameSessionPlayerModel),
  MockSpec<ValueStream<GameModel>>(as: #MockGameStream),
  MockSpec<ValueStream<EndGameModel>>(as: #MockEndGameStream),
])
void main() {
  group('play', () {
    test('plays if the game is not over', () async {
      final client = MockGameClient();
      final game = MockGameModel();
      final activePlayer = MockPlayerModel();
      final player = MockGameSessionPlayerModel();
      final endGame = MockEndGameModel();
      final location = MockLocationModel();
      final controller = GameController(client, player, game, endGame);

      when(game.activePlayer).thenReturn(activePlayer);
      when(activePlayer.color).thenReturn(PlayerColor.Black);
      when(player.color).thenReturn(PlayerColor.Black);
      when(game.created).thenReturn(2);
      when(endGame.created).thenReturn(0);
      when(client.play(location, game)).thenReturn(null);
      controller.play(location);

      verify(client.play(location, game)).called(1);
    });

    test('play is only possible if the game is not over', () {
      final client = MockGameClient();
      final game = MockGameModel();
      final activePlayer = MockPlayerModel();
      final player = MockGameSessionPlayerModel();
      final endGame = MockEndGameModel();
      final location = MockLocationModel();
      final controller = GameController(client, player, game, endGame);

      when(game.activePlayer).thenReturn(activePlayer);
      when(activePlayer.color).thenReturn(PlayerColor.Black);
      when(player.color).thenReturn(PlayerColor.Black);
      when(game.created).thenReturn(1);
      when(endGame.created).thenReturn(2);
      when(client.play(location, game)).thenReturn(null);
      controller.play(location);

      verifyNever(client.play(location, game));
    });

    test('play is only possible if it is not players turn', () {
      final client = MockGameClient();
      final game = MockGameModel();
      final activePlayer = MockPlayerModel();
      final player = MockGameSessionPlayerModel();
      final endGame = MockEndGameModel();
      final location = MockLocationModel();
      final controller = GameController(client, player, game, endGame);

      when(game.activePlayer).thenReturn(activePlayer);
      when(activePlayer.color).thenReturn(PlayerColor.White);
      when(player.color).thenReturn(PlayerColor.Black);
      when(game.created).thenReturn(2);
      when(endGame.created).thenReturn(0);
      when(client.play(location, game)).thenReturn(null);
      controller.play(location);

      verifyNever(client.play(location, game));
    });
  });

  group('isPlayersTurn', () {
    test('players turn', () {
      final client = MockGameClient();
      final activePlayer = MockPlayerModel();
      final player = MockGameSessionPlayerModel();
      final game = MockGameModel();
      final endGame = MockEndGameModel();
      final controller = GameController(client, player, game, endGame);

      when(game.activePlayer).thenReturn(activePlayer);
      when(activePlayer.color).thenReturn(PlayerColor.Black);
      when(player.color).thenReturn(PlayerColor.Black);
      final isPlayersTurn = controller.isPlayersTurn;

      expect(isPlayersTurn, true);
    });

    test('not players turn', () {
      final client = MockGameClient();
      final activePlayer = MockPlayerModel();
      final player = MockGameSessionPlayerModel();
      final game = MockGameModel();
      final endGame = MockEndGameModel();
      final controller = GameController(client, player, game, endGame);

      when(game.activePlayer).thenReturn(activePlayer);
      when(activePlayer.color).thenReturn(PlayerColor.White);
      when(player.color).thenReturn(PlayerColor.Black);
      final isPlayersTurn = controller.isPlayersTurn;

      expect(isPlayersTurn, false);
    });
  });

  group('isGameOver', () {
    test('game is over if the end game is created after the game', () {
      final client = MockGameClient();
      final player = MockGameSessionPlayerModel();
      final game = MockGameModel();
      final endGame = MockEndGameModel();
      final controller = GameController(client, player, game, endGame);

      when(game.created).thenReturn(1);
      when(endGame.created).thenReturn(2);
      final isGameOver = controller.isGameOver;

      expect(isGameOver, true);
    });

    test('game is running if the game is created after the end game', () {
      final client = MockGameClient();
      final player = MockGameSessionPlayerModel();
      final game = MockGameModel();
      final endGame = MockEndGameModel();
      final controller = GameController(client, player, game, endGame);

      when(game.created).thenReturn(2);
      when(endGame.created).thenReturn(1);
      final isGameOver = controller.isGameOver;

      expect(isGameOver, false);
    });
  });

  group('shouldCreateGame', () {
    test('should create game', () {
      final client = MockGameClient();
      final player = MockGameSessionPlayerModel();
      final activePlayer = MockPlayerModel();
      final game = MockGameModel();
      final endGame = MockEndGameModel();
      final controller = GameController(client, player, game, endGame);

      when(game.isPlaying).thenReturn(false);
      when(player.color).thenReturn(PlayerColor.Black);
      when(game.activePlayer).thenReturn(activePlayer);
      when(activePlayer.color).thenReturn(PlayerColor.Black);
      final shouldCreateGame = controller.shouldCreateGame;

      expect(shouldCreateGame, true);
    });

    test('should not create game because game is playing', () {
      final client = MockGameClient();
      final player = MockGameSessionPlayerModel();
      final activePlayer = MockPlayerModel();
      final game = MockGameModel();
      final endGame = MockEndGameModel();
      final controller = GameController(client, player, game, endGame);

      when(game.isPlaying).thenReturn(true);
      when(player.color).thenReturn(PlayerColor.Black);
      when(game.activePlayer).thenReturn(activePlayer);
      when(activePlayer.color).thenReturn(PlayerColor.Black);
      final shouldCreateGame = controller.shouldCreateGame;

      expect(shouldCreateGame, false);
    });

    test('should not create game because player is not active player', () {
      final client = MockGameClient();
      final player = MockGameSessionPlayerModel();
      final activePlayer = MockPlayerModel();
      final game = MockGameModel();
      final endGame = MockEndGameModel();
      final controller = GameController(client, player, game, endGame);

      when(game.isPlaying).thenReturn(false);
      when(player.color).thenReturn(PlayerColor.White);
      when(game.activePlayer).thenReturn(activePlayer);
      when(activePlayer.color).thenReturn(PlayerColor.Black);
      final shouldCreateGame = controller.shouldCreateGame;

      expect(shouldCreateGame, false);
    });
  });

  group('create', () {
    test('creates a game with provided size', () {
      final client = MockGameClient();
      final player = MockGameSessionPlayerModel();
      final game = MockGameModel();
      final endGame = MockEndGameModel();
      final controller = GameController(client, player, game, endGame);

      when(client.create(any)).thenReturn(null);
      controller.create(MockSettingsModel());

      verify(client.create(argThat(isA<MockSettingsModel>()))).called(1);
    });
  });

  group('pass', () {
    test('passes the game with the current game', () {
      final client = MockGameClient();
      final game = MockGameModel();
      final activePlayer = MockPlayerModel();
      final player = MockGameSessionPlayerModel();
      final endGame = MockEndGameModel();
      final controller = GameController(client, player, game, endGame);

      when(game.activePlayer).thenReturn(activePlayer);
      when(activePlayer.color).thenReturn(PlayerColor.Black);
      when(player.color).thenReturn(PlayerColor.Black);
      when(client.pass(any)).thenReturn(null);
      controller.pass();

      verify(client.pass(game)).called(1);
    });

    test('can not pass if it is not players turn', () {
      final client = MockGameClient();
      final game = MockGameModel();
      final activePlayer = MockPlayerModel();
      final player = MockGameSessionPlayerModel();
      final endGame = MockEndGameModel();
      final controller = GameController(client, player, game, endGame);

      when(game.activePlayer).thenReturn(activePlayer);
      when(activePlayer.color).thenReturn(PlayerColor.White);
      when(player.color).thenReturn(PlayerColor.Black);
      when(client.pass(any)).thenReturn(null);
      controller.pass();

      verifyNever(client.pass(game));
    });
  });
}
