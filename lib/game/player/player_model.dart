import 'package:go_app/api/game/common/player_dto.dart';
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

  @override
  String toString() {
    if (_isBlack) {
      return 'Black';
    }

    return 'White';
  }

  bool get _isBlack => color == PlayerColor.Black;
}
