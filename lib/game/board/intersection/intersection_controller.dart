import 'package:go_app/game/board/board_controller.dart';
import 'package:go_app/game/board/intersection/intersection_model.dart';
import 'package:go_app/game/board/intersection/state/state_model.dart';

class IntersectionController {
  final BoardController _boardController;
  final IntersectionModel _intersection;

  const IntersectionController(this._boardController, this._intersection);

  void play() {
    _boardController.play(_intersection.location);
  }

  StateModel get state => _intersection.state;

  int get x => _intersection.location.x;
  int get y => _intersection.location.y;
}
