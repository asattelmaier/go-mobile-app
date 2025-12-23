import 'package:flutter_test/flutter_test.dart';
import 'package:session_server_client/api.dart'; // PlayerDto
import 'package:go_app/game/player/player_color.dart';
import 'package:go_app/game/player/player_model.dart';

void main() {
  group('fromDto', () {
    test('creates a black player if the player dto is black', () {
      final player = PlayerModel.fromDto(
           PlayerDto(id: "id", color: "BLACK", isBot: false));

      expect(player.color, PlayerColor.Black);
    });

    test('creates a white player if the player dto is white', () {
      final player = PlayerModel.fromDto(
           PlayerDto(id: "id", color: "WHITE", isBot: false));

      expect(player.color, PlayerColor.White);
    });
  });

  group('toDto', () {
    test('creates a black player dto if the players color is black', () {
      final player = PlayerModel("test", PlayerColor.Black);

      final dto = player.toDto();

      expect(dto.color, "BLACK");
    });

    test('creates a white player dto if the players color is white', () {
      final player = PlayerModel("test", PlayerColor.White);

      final dto = player.toDto();

      expect(dto.color, "WHITE");
    });
  });
}
