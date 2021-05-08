import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:go_app/api/game/common/game_dto.dart';
import 'package:go_app/api/game/common/location_dto.dart';
import 'package:go_app/api/game/common/player_dto.dart';
import 'package:go_app/api/game/common/state_dto.dart';
import 'package:go_app/api/game/game_client.dart';
import 'package:go_app/api/game/output/command_dto.dart';
import 'package:go_app/api/game/output/create_game_dto.dart';
import 'package:go_app/api/game/output/pass_dto.dart';
import 'package:go_app/api/game/output/play_stone_dto.dart';
import 'package:go_app/api/web_socket/web_socket_client.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'game_client_test.mocks.dart';

@GenerateMocks([WebSocketClient])
void main() {
  group('createGame', () {
    test('sends create game command with size', () {
      final webSocketClient = MockWebSocketClient();
      final client = GameClient(webSocketClient);
      final isSizeFive = predicate<CreateGameDto>((createGame) {
        return createGame.command.size == 5;
      });

      client.createGame(5);

      verify(webSocketClient.sendJson(argThat(isSizeFive))).called(1);
    });
  });

  group('playStone', () {
    test('sends play stone command with game', () {
      final webSocketClient = MockWebSocketClient();
      final client = GameClient(webSocketClient);
      final location = LocationDto(0, 0);
      final game = createEmptyGame();
      final hasPlayStoneCommandAndGame = predicate<PlayStoneDto>((playStone) {
        final name = playStone.command.name;
        return name == CommandDto.PlayStone && playStone.game == game;
      });

      client.playStone(location, game);

      verify(webSocketClient.sendJson(argThat(hasPlayStoneCommandAndGame)))
          .called(1);
    });
  });

  group('pass', () {
    test('sends pass command with game', () {
      final webSocketClient = MockWebSocketClient();
      final client = GameClient(webSocketClient);
      final game = createEmptyGame();
      final hasPassCommandAndGame = predicate<PassDto>((pass) {
        return pass.command.name == CommandDto.Pass && pass.game == game;
      });

      client.pass(game);

      verify(webSocketClient.sendJson(argThat(hasPassCommandAndGame)))
          .called(1);
    });
  });

  group('gameMessages', () {
    test('returns a Game DTO', () async {
      final webSocketClient = MockWebSocketClient();
      final client = GameClient(webSocketClient);
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
      final returnStream = (_) => Stream.value(parsedJson);

      when(webSocketClient.messages).thenAnswer(returnStream);

      client.messages.listen((gameDto) {
        expect(gameDto.activePlayer, PlayerDto.Black);
        expect(gameDto.passivePlayer, PlayerDto.White);
        expect(gameDto.positions[0][0][0].location.x, 0);
        expect(gameDto.positions[0][0][0].location.y, 0);
        expect(gameDto.positions[0][0][0].state, StateDto.Empty);
      });
    });
  });
}

GameDto createEmptyGame() {
  return GameDto(PlayerDto.Black, PlayerDto.White, [
    [[]]
  ]);
}
