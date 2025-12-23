import 'package:go_app/game-session/client/input/player_dto.dart';
import 'package:go_app/game/player/player_color.dart';

class PlayerModel {
  // TODO: Check why an unknown player can be created, this actually makes no sense.
  static const String unknownId = "unknown";
  final String id;
  final PlayerColor color;
  final bool isBot;

  const PlayerModel(this.id, this.color, [this.isBot = false]);

  factory PlayerModel.fromDto(PlayerDto dto) {
    return PlayerModel(dto.id, dto.color, dto.isBot);
  }

  PlayerDto toDto() {
    return PlayerDto(id, color, isBot);
  }

  bool get isBlack => color == PlayerColor.Black;

  bool get isWhite => color == PlayerColor.White;
}
