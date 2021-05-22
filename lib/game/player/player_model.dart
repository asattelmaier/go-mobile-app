import 'package:go_app/game/client/common/player_dto.dart';
import 'package:go_app/game/player/player_color.dart';

class PlayerModel {
  final PlayerColor color;

  PlayerModel(this.color);

  factory PlayerModel.fromDto(PlayerDto dto) {
    if (dto == PlayerDto.Black) {
      return PlayerModel(PlayerColor.Black);
    }

    return PlayerModel(PlayerColor.White);
  }

  PlayerDto toDto() {
    if (color == PlayerColor.Black) {
      return PlayerDto.Black;
    }

    return PlayerDto.White;
  }

  bool get isBlack => color == PlayerColor.Black;

  bool get isWhite => color == PlayerColor.White;
}
