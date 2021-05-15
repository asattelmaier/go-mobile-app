import 'package:go_app/game/end_game/end_game_model.dart';
import 'package:go_app/game/end_game/winner/winner_model.dart';

class EndGameController {
  final EndGameModel _endGame;

  EndGameController(this._endGame);

  WinnerModel get winner => _endGame.winner;

  String get score => _endGame.score.toString();
}
