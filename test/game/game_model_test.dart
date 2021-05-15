import 'package:flutter_test/flutter_test.dart';
import 'package:go_app/game/board/board_model.dart';
import 'package:go_app/game/game_model.dart';
import 'package:go_app/game/player/player_model.dart';
import 'package:go_app/game/positions/positions_model.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'game_model_test.mocks.dart';

@GenerateMocks([PlayerModel, PositionsModel, BoardModel])
void main() {
  group('board', () {
    test('returns positions board', () {
      final positions = MockPositionsModel();
      final board = MockBoardModel();
      final game = GameModel(MockPlayerModel(), MockPlayerModel(), positions);

      when(positions.board).thenReturn(board);

      expect(game.board, board);
    });
  });
}
