import 'package:go_app/api/game/common/player_dto.dart';
import 'package:go_app/game/player/player_color.dart';

class PlayerModel {
  PlayerColor _color;

  PlayerModel(this._color);

  factory PlayerModel.fromDto(PlayerDto dto) {
    if (dto == PlayerDto.Black) {
      return PlayerModel(PlayerColor.Black);
    }

    return PlayerModel(PlayerColor.White);
  }

  PlayerDto toDto() {
    if (_color == PlayerColor.Black) {
      return PlayerDto.Black;
    }

    return PlayerDto.White;
  }
}
