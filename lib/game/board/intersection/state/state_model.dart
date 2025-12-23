import 'package:session_server_client/api.dart';
import 'package:go_app/game/player/player_color.dart';
import 'package:go_app/game/board/intersection/state/stone/stone_model.dart';

class StateModel {
  // TODO: Add maybe type as soon as it is null safety
  //  @see: https://github.com/aloisdeniel/dart_maybe/pull/3
  final StoneModel stone;

  const StateModel(this.stone);

  bool get isEmpty => !stone.isBlack && !stone.isWhite;

  factory StateModel.fromDto(IntersectionDtoStateEnum dto) {
    switch (dto) {
      case IntersectionDtoStateEnum.black:
        return StateModel(StoneModel(PlayerColor.Black));

      case IntersectionDtoStateEnum.white:
        return StateModel(StoneModel(PlayerColor.White));

      default:
        return StateModel(StoneModel(PlayerColor.Empty));
    }
  }

  IntersectionDtoStateEnum toDto() {
    if (stone.isWhite) {
      return IntersectionDtoStateEnum.white;
    }

    if (stone.isBlack) {
      return IntersectionDtoStateEnum.black;
    }

    return IntersectionDtoStateEnum.empty;
  }
}
