import 'package:flutter_test/flutter_test.dart';
import 'package:go_app/game/board/board_controller.dart';
import 'package:go_app/game/board/board_model.dart';
import 'package:go_app/game/board/intersection/location/location_model.dart';
import 'package:go_app/game/game_controller.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'board_controller_test.mocks.dart';

@GenerateMocks([GameController, BoardModel, LocationModel])
void main() {
  group('play', () {
    test('plays with location', () {
      final gameController = MockGameController();
      final board = MockBoardModel();
      final location = MockLocationModel();
      final controller = BoardController(gameController, board);

      when(gameController.play(any)).thenReturn((_) => null);
      controller.play(location);

      verify(gameController.play(location)).called(1);
    });
  });
}
