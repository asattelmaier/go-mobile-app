import 'package:go_app/game/board/board_model.dart';
import 'package:go_app/game/board/intersection/location/location_model.dart';
import 'package:go_app/game/game_controller.dart';

class BoardController {
  final GameController _gameController;
  final BoardModel board;

  BoardController(this._gameController, this.board);

  void play(LocationModel location) {
    _gameController.play(location);
  }
}
