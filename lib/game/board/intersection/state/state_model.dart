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
    if (dto == StateDto.Empty) {
      return StateModel();
    }

    return StateModel(StoneModel(dto as PlayerColor));
  }

  StateDto toDto() {
    if (_isEmpty) {
      return StateDto.Empty;
    }

    return _stone!.color as StateDto;
  }
}
