import 'package:go_app/game/board/intersection/state/stone/stone_model.dart';

class StoneController {
  final StoneModel _stone;

  const StoneController(this._stone);

  bool get isBlack => _stone.isBlack;
}
