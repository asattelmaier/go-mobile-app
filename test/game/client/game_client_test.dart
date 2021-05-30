import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:go_app/game-session/client/game_session_client.dart';
import 'package:go_app/game/board/intersection/location/location_model.dart';
import 'package:go_app/game/client/common/game_dto.dart';
import 'package:go_app/game/client/common/location_dto.dart';
import 'package:go_app/game/client/game_client.dart';
import 'package:go_app/game/client/output/create_dto.dart';
import 'package:go_app/game/client/output/pass_dto.dart';
import 'package:go_app/game/client/output/play_dto.dart';
import 'package:go_app/game/game_model.dart';
import 'package:go_app/game/settings/settings_model.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'game_client_test.mocks.dart';

@GenerateMocks(
    [GameSessionClient, GameModel, LocationModel, GameDto, LocationDto])
void main() {
  group('createGame', () {
    test('sends create game command with board size of 5', () {
      final gameSessionClient = MockGameSessionClient();
      final isSizeFive = predicate<CreateDto>(
          (createGame) => createGame.command.settings.boardSize == 5);
      final settings = SettingsModel(5, false);

      when(gameSessionClient.messages).thenAnswer((_) => Stream.empty());
      GameClient(gameSessionClient).create(settings);

      verify(gameSessionClient.update(argThat(isSizeFive))).called(1);
    });
  });

  group('playStone', () {
    test('sends a PlayStoneDto', () {
      final gameSessionClient = MockGameSessionClient();
      final game = MockGameModel();
      final location = MockLocationModel();

      when(game.toDto()).thenReturn(MockGameDto());
      when(location.toDto()).thenReturn(MockLocationDto());
      when(gameSessionClient.messages).thenAnswer((_) => Stream.empty());
      GameClient(gameSessionClient).play(location, game);

      verify(gameSessionClient.update(argThat(isA<PlayDto>()))).called(1);
    });
  });

  group('pass', () {
    test('sends a PassDto', () {
      final gameSessionClient = MockGameSessionClient();
      final game = MockGameModel();

      when(game.toDto()).thenReturn(MockGameDto());
      when(gameSessionClient.messages).thenAnswer((_) => Stream.empty());
      GameClient(gameSessionClient).pass(game);

      verify(gameSessionClient.update(argThat(isA<PassDto>()))).called(1);
    });
  });

  group('gameMessages', () {
    test('returns a Game Model', () async {
      final gameSessionClient = MockGameSessionClient();
      final parsedJson = {
        "settings": {"boardSize": 4, "isSuicideAllowed": false},
        "activePlayer": "Black",
        "passivePlayer": "White",
        "positions": [
          [
            [
              {
                "location": {"x": 0, "y": 0},
                "state": "Empty"
              }
            ]
          ]
        ]
      };

      when(gameSessionClient.messages)
          .thenAnswer((_) => Stream.value(parsedJson));

      GameClient(gameSessionClient).game.listen((game) {
        expect(game.settings.boardSize, 4);
        expect(game.settings.isSuicideAllowed, false);
        expect(game.activePlayer.isBlack, true);
        expect(game.passivePlayer.isWhite, true);
        expect(game.positions.board.intersections.first.first.location.x, 0);
        expect(game.positions.board.intersections.first.first.location.y, 0);
        expect(
            game.positions.board.intersections.first.first.state.isEmpty, true);
      });
    });

    test('returns a End Game Model', () async {
      final gameSessionClient = MockGameSessionClient();
      final parsedJson = {
        "score": 5,
        "winner": ["White"]
      };

      when(gameSessionClient.messages)
          .thenAnswer((_) => Stream.value(parsedJson));

      GameClient(gameSessionClient).endGame.listen((endGame) {
        expect(endGame.score, 5);
        expect(endGame.winner.hasWhiteWon, true);
      });
    });
  });
}
