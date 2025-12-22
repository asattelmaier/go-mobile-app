import 'package:flutter_test/flutter_test.dart';
import 'package:go_app/game-session/game_session_controller.dart';
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
import 'package:rxdart/rxdart.dart';

import 'game_client_test.mocks.dart';

@GenerateMocks([
  GameSessionController,
  GameModel,
  LocationModel,
  GameDto,
  LocationDto,
  ValueStream
])
void main() {
  group('createGame', () {
    test('sends create game command with board size of 5', () {
      final gameSessionController = MockGameSessionController();
      final isSizeFive = predicate<CreateDto>((createGame) {
        return createGame.command.settings.boardSize == 5;
      });
      final settings = SettingsModel(5);
      final client = createGameClient(gameSessionController);

      client.create(settings);

      verify(gameSessionController.updateSession(argThat(isSizeFive))).called(1);
    });
  });

  group('playStone', () {
    test('sends a PlayStoneDto', () {
      final gameSessionController = MockGameSessionController();
      final game = MockGameModel();
      final location = MockLocationModel();
      final client = createGameClient(gameSessionController);

      when(game.toDto()).thenReturn(MockGameDto());
      when(location.toDto()).thenReturn(MockLocationDto());
      client.play(location, game);

      verify(gameSessionController.updateSession(argThat(isA<PlayDto>()))).called(1);
    });
  });

  group('pass', () {
    test('sends a PassDto', () {
      final gameSessionController = MockGameSessionController();
      final game = MockGameModel();
      final client = createGameClient(gameSessionController);

      when(game.toDto()).thenReturn(MockGameDto());
      client.pass(game);

      verify(gameSessionController.updateSession(argThat(isA<PassDto>()))).called(1);
    });
  });
}

createGameClient(GameSessionController gameSessionController,
    [MockValueStream<Map<String, dynamic>>? message]) {
  final returnMessage = (_) {
    return message == null ? MockValueStream<Map<String, dynamic>>() : message;
  };

  when(gameSessionController.messages).thenAnswer(returnMessage);

  return GameClient(gameSessionController);
}
