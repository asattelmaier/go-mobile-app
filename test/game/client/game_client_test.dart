import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:go_app/api/web_socket/web_socket_client.dart';
import 'package:go_app/game/board/intersection/location/location_model.dart';
import 'package:go_app/game/client/common/game_dto.dart';
import 'package:go_app/game/client/common/location_dto.dart';
import 'package:go_app/game/client/game_client.dart';
import 'package:go_app/game/client/output/create_dto.dart';
import 'package:go_app/game/client/output/pass_dto.dart';
import 'package:go_app/game/client/output/play_dto.dart';
import 'package:go_app/game/game_model.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'game_client_test.mocks.dart';

@GenerateMocks(
    [WebSocketClient, GameModel, LocationModel, GameDto, LocationDto])
void main() {
  group('createGame', () {
    test('sends create game command with size', () {
      final webSocketClient = MockWebSocketClient();
      final isSizeFive =
          predicate<CreateDto>((createGame) => createGame.command.size == 5);

      when(webSocketClient.messages).thenAnswer((_) => Stream.empty());
      GameClient(webSocketClient).create(5);

      verify(webSocketClient.sendJson(argThat(isSizeFive))).called(1);
    });
  });

  group('playStone', () {
    test('sends a PlayStoneDto', () {
      final webSocketClient = MockWebSocketClient();
      final game = MockGameModel();
      final location = MockLocationModel();

      when(game.toDto()).thenReturn(MockGameDto());
      when(location.toDto()).thenReturn(MockLocationDto());
      when(webSocketClient.messages).thenAnswer((_) => Stream.empty());
      GameClient(webSocketClient).play(location, game);

      verify(webSocketClient.sendJson(argThat(isA<PlayDto>()))).called(1);
    });
  });

  group('pass', () {
    test('sends a PassDto', () {
      final webSocketClient = MockWebSocketClient();
      final game = MockGameModel();

      when(game.toDto()).thenReturn(MockGameDto());
      when(webSocketClient.messages).thenAnswer((_) => Stream.empty());
      GameClient(webSocketClient).pass(game);

      verify(webSocketClient.sendJson(argThat(isA<PassDto>()))).called(1);
    });
  });

  group('gameMessages', () {
    test('returns a Game Model', () async {
      final webSocketClient = MockWebSocketClient();
      final parsedJson = {
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

      when(webSocketClient.messages)
          .thenAnswer((_) => Stream.value(parsedJson));

      GameClient(webSocketClient).game.listen((game) {
        expect(game.activePlayer.isBlack, true);
        expect(game.passivePlayer.isWhite, true);
        expect(game.positions.board.intersections.first.first.location.x, 0);
        expect(game.positions.board.intersections.first.first.location.y, 0);
        expect(
            game.positions.board.intersections.first.first.state.isEmpty, true);
      });
    });

    test('returns a End Game Model', () async {
      final webSocketClient = MockWebSocketClient();
      final parsedJson = {
        "score": 5,
        "winner": ["White"]
      };

      when(webSocketClient.messages)
          .thenAnswer((_) => Stream.value(parsedJson));

      GameClient(webSocketClient).endGame.listen((endGame) {
        expect(endGame.score, 5);
        expect(endGame.winner.hasWhiteWon, true);
      });
    });
  });
}
