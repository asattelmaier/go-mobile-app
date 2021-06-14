import 'package:go_app/game-session/client/input/player_dto.dart';
import 'package:go_app/game/player/player_color.dart';

class SessionPlayerModel {
  final String id;
  final PlayerColor color;

  const SessionPlayerModel(this.id, this.color);

  factory SessionPlayerModel.fromDto(PlayerDto dto) {
    return SessionPlayerModel(dto.id, dto.color);
  }

  const SessionPlayerModel.empty()
      : this.id = "",
        this.color = PlayerColor.Empty;
}
