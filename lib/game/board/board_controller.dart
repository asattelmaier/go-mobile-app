import 'package:go_app/game/board/board_model.dart';
import 'package:go_app/game/board/intersection/intersection_model.dart';
import 'package:go_app/game/board/intersection/location/location_model.dart';
import 'package:go_app/game/game_controller.dart';

class BoardController {
  final GameController _gameController;
  final BoardModel _board;

  BoardController(this._gameController, this._board);

  void play(LocationModel location) {
    _gameController.play(location);
  }

  bool get isBoardEmpty => _board.isEmpty;

  int get size => _board.size;

  List<List<IntersectionModel>> get intersections => _board.intersections;
}
