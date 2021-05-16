import 'package:flutter_test/flutter_test.dart';
import 'package:go_app/game/client/common/game_dto.dart';

void main() {
  group('isGameDto', () {
    test('returns true if JSON is a GameDto', () {
      Map<String, dynamic> json = {
        "activePlayer": 'Black',
        "passivePlayer": 'White',
        "positions": []
      };

      bool isGameDto = GameDto.isGameDto(json);

      expect(isGameDto, true);
    });

    test('returns false if JSON is empty', () {
      Map<String, dynamic> json = {};

      bool isGameDto = GameDto.isGameDto(json);

      expect(isGameDto, false);
    });

    test('returns false if JSON is not a GameDto', () {
      Map<String, dynamic> json = {
        "activePlayer": 'Black',
        "passivePlayer": 'White',
        "test": []
      };

      bool isGameDto = GameDto.isGameDto(json);

      expect(isGameDto, false);
    });
  });
}
