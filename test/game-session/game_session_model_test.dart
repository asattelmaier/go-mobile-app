import 'package:flutter_test/flutter_test.dart';
import 'package:go_app/game-session/game_session_model.dart';
import 'package:go_app/game-session/player/player_model.dart';
import 'package:mockito/annotations.dart';
import 'game_session_model_test.mocks.dart';

@GenerateMocks([PlayerModel])
void main() {
  group('isPending', () {
    test('is pending if session has one players', () {
      final players = [MockPlayerModel()];
      final gameSession = GameSessionModel("", players);

      final isPending = gameSession.isPending;

      expect(isPending, true);
    });

    test('is not pending if session less no one players', () {
      final gameSession = GameSessionModel("", []);

      final isPending = gameSession.isPending;

      expect(isPending, false);
    });

    test('is not pending if session has more than one player', () {
      final players = [MockPlayerModel(), MockPlayerModel()];
      final gameSession = GameSessionModel("", players);

      final isPending = gameSession.isPending;

      expect(isPending, false);
    });
  });
}
