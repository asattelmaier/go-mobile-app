import 'package:go_app/game/client/common/state_dto.dart';
import 'package:go_app/game/player/player_color.dart';
import 'package:go_app/game/board/intersection/state/stone/stone_model.dart';

class StateModel {
  // TODO: Add maybe type as soon as it is null safety
  //  @see: https://github.com/aloisdeniel/dart_maybe/pull/3
  final StoneModel stone;

  StateModel(this.stone);

  bool get isEmpty => !stone.isBlack && !stone.isWhite;

  factory StateModel.fromDto(StateDto dto) {
    switch (dto) {
      case StateDto.Black:
        return StateModel(StoneModel(PlayerColor.Black));

      case StateDto.White:
        return StateModel(StoneModel(PlayerColor.White));

      default:
        return StateModel(StoneModel(PlayerColor.Empty));
    }
  }

  StateDto toDto() {
    if (stone.isWhite) {
      return StateDto.White;
    }

    if (stone.isBlack) {
      return StateDto.Black;
    }

    return StateDto.Empty;
  }
}
