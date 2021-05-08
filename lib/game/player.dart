import 'package:flutter/cupertino.dart';
import 'package:go_app/api/game/common/player_dto.dart';
import 'package:go_app/game/color.dart';

class Player {
  Color _color;

  Player(this._color);

  factory Player.fromDto(PlayerDto dto) {
    if (dto == PlayerDto.Black) {
      return Player(Color.Black);
    }

    return Player(Color.White);
  }

  PlayerDto toDto() {
    if (_color == Color.Black) {
      return PlayerDto.Black;
    }

    return PlayerDto.White;
  }
}
