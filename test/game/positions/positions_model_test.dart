import 'package:flutter_test/flutter_test.dart';
import 'package:go_app/game/board/board_model.dart';
import 'package:go_app/game/positions/positions_model.dart';
import 'package:mockito/annotations.dart';
import 'positions_model_test.mocks.dart';

@GenerateMocks([BoardModel])
void main() {
  group('empty', () {
    test('has a empty board', () {
      final positions = PositionsModel.empty();

      final board = positions.board;

      expect(board.size, 0);
    });
  });

  group('board', () {
    test('returns the latest board', () {
      final firstBoard = MockBoardModel();
      final secondBoard = MockBoardModel();
      final positions = PositionsModel([firstBoard, secondBoard]);

      final board = positions.board;

      expect(board, firstBoard);
    });
  });
}
