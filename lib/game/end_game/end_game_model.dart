import 'package:go_app/game/client/input/end_game_dto.dart';
import 'package:go_app/game/end_game/winner/winner_model.dart';

class EndGameModel {
  final WinnerModel winner;
  final int score;

  EndGameModel(this.score, this.winner);

  EndGameModel.empty()
      : this.score = 0,
        this.winner = WinnerModel.empty();

  bool get isGameOver => score != 0 || winner.hasWinner;

  factory EndGameModel.fromNullable(EndGameModel? endGame) {
    if (endGame == null) {
      return EndGameModel.empty();
    }

    return endGame;
  }

  factory EndGameModel.fromDto(EndGameDto dto) =>
      EndGameModel(dto.score, WinnerModel.fromDto(dto.winner));
}
