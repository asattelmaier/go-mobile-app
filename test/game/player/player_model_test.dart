import 'package:flutter_test/flutter_test.dart';
import 'package:go_app/game-session/client/input/player_dto.dart';
import 'package:go_app/game/player/player_color.dart';
import 'package:go_app/game/player/player_model.dart';

void main() {
  group('fromDto', () {
    test('creates a black player if the player dto is black', () {
      final player = PlayerModel.fromDto(
          const PlayerDto("id", PlayerColor.Black, false));

      expect(player.color, PlayerColor.Black);
    });

    test('creates a white player if the player dto is white', () {
      final player = PlayerModel.fromDto(
          const PlayerDto("id", PlayerColor.White, false));

      expect(player.color, PlayerColor.White);
    });
  });

  group('toDto', () {
    test('creates a black player dto if the players color is black', () {
      final player = PlayerModel("test", PlayerColor.Black);

      final dto = player.toDto();

      expect(dto.color, PlayerColor.Black);
    });

    test('creates a white player dto if the players color is white', () {
      final player = PlayerModel("test", PlayerColor.White);

      final dto = player.toDto();

      expect(dto.color, PlayerColor.White);
    });
  });
}
