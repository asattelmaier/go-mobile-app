import 'package:go_app/api/game/common/state_dto.dart';
import 'package:go_app/game/color.dart';
import 'package:go_app/game/stone.dart';

class State {
  // TODO: Add maybe type as soon as it is null safety
  //  @see: https://github.com/aloisdeniel/dart_maybe/pull/3
  Stone? _stone;

  State([this._stone]);

  bool get _isEmpty => _stone == null;

  factory State.fromDto(StateDto dto) {
    if (dto == StateDto.Empty) {
      return State();
    }

    return State(Stone(dto as Color));
  }

  StateDto toDto() {
    if (_isEmpty) {
      return StateDto.Empty;
    }

    return _stone!.color as StateDto;
  }
}
