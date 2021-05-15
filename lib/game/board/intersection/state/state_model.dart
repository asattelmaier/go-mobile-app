import 'package:go_app/api/game/common/state_dto.dart';
import 'package:go_app/game/player/player_color.dart';
import 'package:go_app/game/board/intersection/state/stone/stone_model.dart';

class StateModel {
  // TODO: Add maybe type as soon as it is null safety
  //  @see: https://github.com/aloisdeniel/dart_maybe/pull/3
  StoneModel? _stone;

  StateModel([this._stone]);

  bool get _isEmpty => _stone == null;

  factory StateModel.fromDto(StateDto dto) {
    switch (dto) {
      case StateDto.Black:
        return StateModel(StoneModel(PlayerColor.Black));

      case StateDto.White:
        return StateModel(StoneModel(PlayerColor.White));

      default:
        return StateModel();
    }
  }

  StateDto toDto() {
    if (_isEmpty) {
      return StateDto.Empty;
    }

    if (_stone!.isBlack) {
      return StateDto.Black;
    }

    return StateDto.White;
  }
}
