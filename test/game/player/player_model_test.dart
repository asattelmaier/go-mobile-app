import 'package:flutter_test/flutter_test.dart';
import 'package:go_app/game/client/common/player_dto.dart';
import 'package:go_app/game/player/player_color.dart';
import 'package:go_app/game/player/player_model.dart';

void main() {
  group('fromDto', () {
    test('creates a black player if the player dto is black', () {
      final player = PlayerModel.fromDto(PlayerDto.Black);

      expect(player.color, PlayerColor.Black);
    });

    test('creates a white player if the player dto is white', () {
      final player = PlayerModel.fromDto(PlayerDto.White);

      expect(player.color, PlayerColor.White);
    });
  });

  group('toDto', () {
    test('creates a black player dto if the players color is black', () {
      final player = PlayerModel(PlayerColor.Black);

      final dto = player.toDto();

      expect(dto, PlayerDto.Black);
    });

    test('creates a white player dto if the players color is white', () {
      final player = PlayerModel(PlayerColor.White);

      final dto = player.toDto();

      expect(dto, PlayerDto.White);
    });
  });
}
