import 'package:flutter_test/flutter_test.dart';
import 'package:go_app/api/game/common/state_dto.dart';
import 'package:go_app/game/board/intersection/state/state_model.dart';
import 'package:go_app/game/board/intersection/state/stone/stone_model.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'state_model_test.mocks.dart';

@GenerateMocks([StoneModel])
void main() {
  group('isEmpty', () {
    test('is true if state is empty', () {
      final stone = MockStoneModel();
      final state = StateModel(stone);

      when(stone.isBlack).thenReturn(false);
      when(stone.isWhite).thenReturn(false);
      final isEmpty = state.isEmpty;

      expect(isEmpty, true);
    });

    test('is false if state is not empty', () {
      final stone = MockStoneModel();
      final state = StateModel(stone);

      when(stone.isBlack).thenReturn(true);
      when(stone.isWhite).thenReturn(false);
      final isEmpty = state.isEmpty;

      expect(isEmpty, false);
    });
  });

  group('fromDto', () {
    test('returns a black stone if dto is black', () {
      final dto = StateDto.Black;

      final state = StateModel.fromDto(dto);

      expect(state.stone.isBlack, true);
    });

    test('returns a white stone if dto is white', () {
      final dto = StateDto.White;

      final state = StateModel.fromDto(dto);

      expect(state.stone.isWhite, true);
    });

    test('returns a empty state if dto is empty', () {
      final dto = StateDto.Empty;

      final state = StateModel.fromDto(dto);

      expect(state.isEmpty, true);
    });
  });

  group('toDto', () {
    test('creates an black dto if stone is black', () {
      final stone = MockStoneModel();
      final state = StateModel(stone);

      when(stone.isBlack).thenReturn(true);
      when(stone.isWhite).thenReturn(false);
      final dto = state.toDto();

      expect(dto, StateDto.Black);
    });

    test('creates an white dto if stone is white', () {
      final stone = MockStoneModel();
      final state = StateModel(stone);

      when(stone.isBlack).thenReturn(false);
      when(stone.isWhite).thenReturn(true);
      final dto = state.toDto();

      expect(dto, StateDto.White);
    });

    test('creates an empty dto if state is empty', () {
      final stone = MockStoneModel();
      final state = StateModel(stone);

      when(stone.isWhite).thenReturn(false);
      when(stone.isBlack).thenReturn(false);
      final dto = state.toDto();

      expect(dto, StateDto.Empty);
    });
  });
}
