import 'package:go_app/game-session/client/input/player_dto.dart';
import 'package:go_app/game/player/player_color.dart';

class SessionPlayerModel {
  final String id;
  final PlayerColor color;
  final bool isBot;

  const SessionPlayerModel(this.id, this.color, [this.isBot = false]);

  factory SessionPlayerModel.fromDto(PlayerDto dto) {
    return SessionPlayerModel(dto.id, dto.color, dto.isBot);
  }

  const SessionPlayerModel.empty()
      : this.id = "",
        this.color = PlayerColor.Empty,
        this.isBot = false;
}
