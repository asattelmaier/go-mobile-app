import 'package:flutter_test/flutter_test.dart';
import 'package:go_app/game/board/board_model.dart';

void main() {
  group('size', () {
    test('returns intersection length', () {
      final board = BoardModel([[], [], []]);

      final size = board.size;

      expect(size, 3);
    });
  });

  group('empty', () {
    test('creates an empty board', () {
      final board = BoardModel.empty();

      final size = board.size;

      expect(size, 0);
    });
  });

  group('isEmpty', () {
    test('is true if size is zero', () {
      final board = BoardModel.empty();

      final isEmpty = board.isEmpty;

      expect(isEmpty, true);
    });

    test('is false if size > zero', () {
      final board = BoardModel([[]]);

      final isEmpty = board.isEmpty;

      expect(isEmpty, false);
    });
  });
}
