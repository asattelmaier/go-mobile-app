import 'package:flutter_test/flutter_test.dart';
import 'package:go_app/game/client/input/end_game_dto.dart';

void main() {
  group('isEndGameDto', () {
    test('returns true if JSON is a EndGameDto', () {
      Map<String, dynamic> json = {
        "score": 2,
        "winner": []
      };

      bool isEndGameDto = EndGameDto.isEndGameDto(json);

      expect(isEndGameDto, true);
    });

    test('returns false if JSON is empty', () {
      Map<String, dynamic> json = {};

      bool isEndGameDto = EndGameDto.isEndGameDto(json);

      expect(isEndGameDto, false);
    });

    test('returns false if JSON is not a GameDto', () {
      Map<String, dynamic> json = {
        "score": 2,
        "test": []
      };

      bool isEndGameDto = EndGameDto.isEndGameDto(json);

      expect(isEndGameDto, false);
    });
  });
}
