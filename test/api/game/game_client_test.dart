import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:go_app/api/game/common/location_dto.dart';
import 'package:go_app/api/game/common/player_dto.dart';
import 'package:go_app/api/game/common/state_dto.dart';
import 'package:go_app/api/game/game_client.dart';
import 'package:go_app/api/game/output/create_game_dto.dart';
import 'package:go_app/api/game/output/pass_dto.dart';
import 'package:go_app/api/game/output/play_stone_dto.dart';
import 'package:go_app/api/web_socket/web_socket_client.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import '../../_utils/_utils.dart';
import 'game_client_test.mocks.dart';

@GenerateMocks([WebSocketClient])
void main() {
  group('createGame', () {
    test('sends create game command with size', () {
      final webSocketClient = MockWebSocketClient();
      final isSizeFive = predicate<CreateGameDto>(
          (createGame) => createGame.command.size == 5);

      when(webSocketClient.messages).thenAnswer((_) => Stream.empty());
      GameClient(webSocketClient).createGame(5);

      verify(webSocketClient.sendJson(argThat(isSizeFive))).called(1);
    });
  });

  group('playStone', () {
    test('sends a PlayStoneDto', () {
      final webSocketClient = MockWebSocketClient();
      final location = LocationDto(0, 0);
      final game = createGame();

      when(webSocketClient.messages).thenAnswer((_) => Stream.empty());
      GameClient(webSocketClient).playStone(location, game);

      verify(webSocketClient.sendJson(argThat(isA<PlayStoneDto>()))).called(1);
    });
  });

  group('pass', () {
    test('sends a PassDto', () {
      final webSocketClient = MockWebSocketClient();
      final game = createGame();

      when(webSocketClient.messages).thenAnswer((_) => Stream.empty());
      GameClient(webSocketClient).pass(game);

      verify(webSocketClient.sendJson(argThat(isA<PassDto>()))).called(1);
    });
  });

  group('gameMessages', () {
    test('returns a Game DTO', () async {
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

      when(webSocketClient.messages).thenAnswer((_) => Stream.value(parsedJson));

      GameClient(webSocketClient).game.listen((gameDto) {
        expect(gameDto.activePlayer, PlayerDto.Black);
        expect(gameDto.passivePlayer, PlayerDto.White);
        expect(gameDto.positions.first.first.first.location.x, 0);
        expect(gameDto.positions.first.first.first.location.y, 0);
        expect(gameDto.positions.first.first.first.state, StateDto.Empty);
      });
    });
  });
}
