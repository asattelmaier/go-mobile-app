import 'package:go_app/game/end_game/winner/winner_model.dart';

class WinnerController {
  final WinnerModel _winner;

  WinnerController(this._winner);

  WinnerModel get winner => _winner;

  bool get isDrawn => winner.isDrawn;

  bool get hasWhiteWon => winner.hasWhiteWon;
}
