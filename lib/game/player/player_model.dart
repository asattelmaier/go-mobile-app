import 'package:go_app/api/game/common/player_dto.dart';
import 'package:go_app/game/player/player_color.dart';

class Player {
  PlayerColor _color;

  Player(this._color);

  factory Player.fromDto(PlayerDto dto) {
    if (dto == PlayerDto.Black) {
      return Player(PlayerColor.Black);
    }

    return Player(PlayerColor.White);
  }

  PlayerDto toDto() {
    if (_color == PlayerColor.Black) {
      return PlayerDto.Black;
    }

    return PlayerDto.White;
  }
}
