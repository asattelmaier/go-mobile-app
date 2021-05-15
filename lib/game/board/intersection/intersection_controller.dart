import 'package:go_app/game/board/board_controller.dart';
import 'package:go_app/game/board/intersection/intersection_model.dart';

class IntersectionController {
  final BoardController _boardController;
  final IntersectionModel _intersection;

  IntersectionController(this._boardController, this._intersection);

  void play() {
    _boardController.play(_intersection.location);
  }
}
