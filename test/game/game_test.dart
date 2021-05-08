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
  group('playStone', () {
    test('sends a LocationDto and GameDto', () async {
      final client = MockGameClient();
      final game = Game(client);
      final location = Location(0, 0);
      final returnGameDto = (_) => Stream.value(createGame());

      when(client.game).thenAnswer(returnGameDto);
      when(client.playStone(any, any)).thenReturn(null);
      await game.playStone(location);

      verify(client.playStone(
              argThat(isA<LocationDto>()), argThat(isA<GameDto>())))
          .called(1);
    });
  });

  group('create', () {
    test('creates a game with provided size', () {
      final client = MockGameClient();
      final game = Game(client);

      when(client.createGame(any)).thenReturn(null);
      game.create(5);

      verify(client.createGame(argThat(equals(5)))).called(1);
    });
  });

  group('pass', () {
    test('passes the game with the current game', () async {
      final client = MockGameClient();
      final game = Game(client);
      final returnGameDto = (_) => Stream.value(createGame());

      when(client.game).thenAnswer(returnGameDto);
      when(client.pass(any)).thenReturn(null);
      await game.pass();

      verify(client.pass(argThat(isA<GameDto>()))).called(1);
    });
  });
}
