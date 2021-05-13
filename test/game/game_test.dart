import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:go_app/api/game/common/game_dto.dart';
import 'package:go_app/api/game/common/location_dto.dart';
import 'package:go_app/game/location.dart';
import 'package:mockito/mockito.dart';
import 'package:go_app/game/game.dart';
import 'package:mockito/annotations.dart';
import 'package:go_app/api/game/game_client.dart';
import '../_utils/_utils.dart';
import 'game_test.mocks.dart';

@GenerateMocks([GameClient])
void main() {
  group('board', () {
    test('returns a board', () async {
      final client = MockGameClient();

      when(client.game).thenAnswer((_) => Stream.value(createGame(2)));

      Game(client).board.listen((board) => expect(board.rows, 2));
    });
  });

  group('playStone', () {
    test('sends a LocationDto and GameDto', () async {
      final client = MockGameClient();
      final location = Location(0, 0);

      when(client.game).thenAnswer((_) => Stream.value(createGame()));
      when(client.playStone(any, any)).thenReturn(null);
      Game(client).playStone(location);

      verify(client.playStone(
              argThat(isA<LocationDto>()), argThat(isA<GameDto>())))
          .called(1);
    });

    test('sends a LocationDto and empty GameDto if GameDto is not present',
        () async {
      final client = MockGameClient();
      final location = Location(0, 0);

      when(client.game).thenAnswer((_) => Stream.empty());
      when(client.playStone(any, any)).thenReturn(null);
      Game(client).playStone(location);

      verify(client.playStone(
              argThat(isA<LocationDto>()), argThat(isA<GameDto>())))
          .called(1);
    });
  });

  group('create', () {
    test('creates a game with provided size', () {
      final client = MockGameClient();

      when(client.game).thenAnswer((_) => Stream.empty());
      when(client.createGame(any)).thenReturn(null);
      Game(client).create(5);

      verify(client.createGame(argThat(equals(5)))).called(1);
    });
  });

  group('pass', () {
    test('passes the game with the current game', () {
      final client = MockGameClient();

      when(client.game).thenAnswer((_) => Stream.value(createGame(1)));
      when(client.pass(any)).thenReturn(null);
      Game(client).pass();

      verify(client.pass(argThat(isA<GameDto>()))).called(1);
    });
  });
}
