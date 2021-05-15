import 'package:flutter_test/flutter_test.dart';
import 'package:go_app/game/end_game/winner/winner_model.dart';
import 'package:go_app/game/player/player_model.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'winner_model_test.mocks.dart';

@GenerateMocks([PlayerModel])
void main() {
  group('isDrawn', () {
    test('returns true if white and black player has won', () {
      final white = MockPlayerModel();
      final black = MockPlayerModel();
      final winner = WinnerModel([white, black]);

      when(white.isWhite).thenReturn(true);
      when(white.isBlack).thenReturn(false);
      when(black.isWhite).thenReturn(false);
      when(black.isBlack).thenReturn(true);
      final isDrawn = winner.isDrawn;

      expect(isDrawn, true);
    });

    test('returns false if only white has won', () {
      final white = MockPlayerModel();
      final winner = WinnerModel([white]);

      when(white.isWhite).thenReturn(true);
      when(white.isBlack).thenReturn(false);
      final isDrawn = winner.isDrawn;

      expect(isDrawn, false);
    });

    test('returns false if only black has won', () {
      final black = MockPlayerModel();
      final winner = WinnerModel([black]);

      when(black.isBlack).thenReturn(true);
      when(black.isWhite).thenReturn(false);
      final isDrawn = winner.isDrawn;

      expect(isDrawn, false);
    });
  });

  group('hasWhiteWon', () {
    test('returns true if white is a winner', () {
      final white = MockPlayerModel();
      final winner = WinnerModel([white]);

      when(white.isWhite).thenReturn(true);
      when(white.isBlack).thenReturn(false);
      final hasWhiteWon = winner.hasWhiteWon;

      expect(hasWhiteWon, true);
    });

    test('returns false if white is not a winner', () {
      final black = MockPlayerModel();
      final winner = WinnerModel([black]);

      when(black.isWhite).thenReturn(false);
      when(black.isBlack).thenReturn(true);
      final hasWhiteWon = winner.hasWhiteWon;

      expect(hasWhiteWon, false);
    });
  });

  group('hasBlackWon', () {
    test('returns false if black is a not winner', () {
      final white = MockPlayerModel();
      final winner = WinnerModel([white]);

      when(white.isWhite).thenReturn(true);
      when(white.isBlack).thenReturn(false);
      final hasBlackWon = winner.hasBlackWon;

      expect(hasBlackWon, false);
    });

    test('returns true if black is a winner', () {
      final black = MockPlayerModel();
      final winner = WinnerModel([black]);

      when(black.isWhite).thenReturn(false);
      when(black.isBlack).thenReturn(true);
      final hasBlackWon = winner.hasBlackWon;

      expect(hasBlackWon, true);
    });
  });
}
