import 'package:go_app/api/game/input/end_game_dto.dart';
import 'package:go_app/game/end_game/winner/winner_model.dart';

class EndGameModel {
  final WinnerModel winner;
  final int score;

  EndGameModel(this.score, this.winner);

  factory EndGameModel.fromDto(EndGameDto dto) =>
      EndGameModel(dto.score, WinnerModel.fromDto(dto.winner));
}
