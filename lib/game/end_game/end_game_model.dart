import 'package:go_app/game/client/input/end_game_dto.dart';
import 'package:go_app/game/end_game/winner/winner_model.dart';

class EndGameModel {
  final WinnerModel winner;
  final int score;
  final int created;

  EndGameModel(this.score, this.winner)
      : this.created = DateTime.now().millisecondsSinceEpoch;

  EndGameModel.empty()
      : this.score = 0,
        this.winner = WinnerModel.empty(),
        this.created = 0;

  factory EndGameModel.fromNullable(EndGameModel? endGame) {
    if (endGame == null) {
      return EndGameModel.empty();
    }

    return endGame;
  }

  factory EndGameModel.fromDto(EndGameDto dto) =>
      EndGameModel(dto.score, WinnerModel.fromDto(dto.winner));
}
