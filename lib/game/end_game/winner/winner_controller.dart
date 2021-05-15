import 'package:go_app/game/end_game/winner/winner_model.dart';

class WinnerController {
  final WinnerModel _winner;

  WinnerController(this._winner);

  String get winner => _winner.toString();
}
