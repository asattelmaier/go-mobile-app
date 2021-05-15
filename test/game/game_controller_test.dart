import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:go_app/api/game/common/game_dto.dart';
import 'package:go_app/api/game/common/location_dto.dart';
import 'package:go_app/game/game_controller.dart';
import 'package:go_app/game/board/intersection/location/location_model.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:go_app/api/game/game_client.dart';
import '../_utils/_utils.dart';
import 'game_controller_test.mocks.dart';

@GenerateMocks([GameClient])
void main() {
  group('board', () {
    test('returns a board', () async {
      final client = MockGameClient();

      when(client.game).thenAnswer((_) => Stream.value(createGame(2)));

      GameController(client).game.listen((game) => expect(game.board.size, 2));
    });
  });

  group('play', () {
    test('sends a LocationDto and GameDto', () async {
      final client = MockGameClient();
      final location = LocationModel(0, 0);

      when(client.game).thenAnswer((_) => Stream.value(createGame()));
      when(client.play(any, any)).thenReturn(null);
      GameController(client).play(location);

      verify(client.play(argThat(isA<LocationDto>()), argThat(isA<GameDto>())))
          .called(1);
    });

    test('sends a LocationDto and an empty GameDto', () async {
      final client = MockGameClient();
      final location = LocationModel(0, 0);

      when(client.game).thenAnswer((_) => Stream.empty());
      when(client.play(any, any)).thenReturn(null);
      GameController(client).play(location);

      verify(client.play(argThat(isA<LocationDto>()), argThat(isA<GameDto>())))
          .called(1);
    });
  });

  group('create', () {
    test('creates a game with provided size', () {
      final client = MockGameClient();

      when(client.game).thenAnswer((_) => Stream.empty());
      when(client.create(any)).thenReturn(null);
      GameController(client).create(5);

      verify(client.create(argThat(equals(5)))).called(1);
    });
  });

  group('pass', () {
    test('passes the game with the current game', () {
      final client = MockGameClient();

      when(client.game).thenAnswer((_) => Stream.value(createGame(1)));
      when(client.pass(any)).thenReturn(null);
      GameController(client).pass();

      verify(client.pass(argThat(isA<GameDto>()))).called(1);
    });
  });
}
