import 'package:flutter_test/flutter_test.dart';
import 'package:go_app/game/game_model.dart';
import 'package:go_app/game/player/player_model.dart';
import 'package:go_app/game/positions/positions_model.dart';
import 'package:mockito/annotations.dart';
import 'game_model_test.mocks.dart';

@GenerateMocks([PlayerModel, PositionsModel])
void main() {
  group('fromNullable', () {
    test('returns given instance if it is not null', () {
      final game =
          GameModel(MockPlayerModel(), MockPlayerModel(), MockPositionsModel());

      final gameFromNullable = GameModel.fromNullable(game);

      expect(gameFromNullable, game);
    });


    test('returns empty game if given instance is null', () {
      final game = null;

      final gameFromNullable = GameModel.fromNullable(game);

      expect(gameFromNullable.positions.board.size, 0);
    });
  });
}
