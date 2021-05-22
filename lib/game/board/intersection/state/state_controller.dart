import 'package:go_app/game/board/intersection/state/state_model.dart';
import 'package:go_app/game/board/intersection/state/stone/stone_model.dart';

class StateController {
  final StateModel _state;

  const StateController(this._state);

  bool get isEmpty => _state.isEmpty;

  StoneModel get stone => _state.stone;
}
