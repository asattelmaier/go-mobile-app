import 'package:flutter_test/flutter_test.dart';
import 'package:go_app/game/board/board_controller.dart';
import 'package:go_app/game/board/intersection/intersection_controller.dart';
import 'package:go_app/game/board/intersection/intersection_model.dart';
import 'package:go_app/game/board/intersection/location/location_model.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'intersection_controller_test.mocks.dart';

@GenerateMocks([BoardController, IntersectionModel, LocationModel])
void main() {
  group('play', () {
    test('plays with intersections location', () {
      final boardController = MockBoardController();
      final intersection = MockIntersectionModel();
      final location = MockLocationModel();
      final controller = IntersectionController(boardController, intersection);

      when(intersection.location).thenReturn(location);
      when(boardController.play(any)).thenReturn((_) => null);
      controller.play();

      verify(boardController.play(location)).called(1);
    });
  });
}
