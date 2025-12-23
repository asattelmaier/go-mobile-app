import 'package:session_server_client/api.dart';
import 'package:go_app/game/end_game/winner/winner_model.dart';

class EndGameModel {
  final WinnerModel winner;
  final double score;
  final int created;

  EndGameModel(this.score, this.winner)
      : this.created = DateTime.now().millisecondsSinceEpoch;

  const EndGameModel.empty()
      : this.score = 0.0,
        this.winner = const WinnerModel.empty(),
        this.created = 0;

  factory EndGameModel.fromNullable(EndGameModel? endGame) {
    if (endGame == null) {
      return EndGameModel.empty();
    }

    return endGame;
  }

  factory EndGameModel.fromDto(EndGameDto dto) =>
      EndGameModel(dto.score ?? 0.0, WinnerModel.fromDto(dto.winner));
}
