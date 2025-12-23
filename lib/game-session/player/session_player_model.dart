import 'package:session_server_client/api.dart'; // PlayerDto
import 'package:go_app/game/player/player_color.dart';

class SessionPlayerModel {
  final String id;
  final PlayerColor color;
  final bool isBot;

  const SessionPlayerModel(this.id, this.color, [this.isBot = false]);

  factory SessionPlayerModel.fromDto(PlayerDto dto) {
    final color = PlayerColor.values.firstWhere(
        (e) => e.name.toUpperCase() == (dto.color ?? "").toUpperCase(),
        orElse: () => PlayerColor.Empty);

    return SessionPlayerModel(dto.id ?? "", color, dto.isBot ?? false);
  }

  const SessionPlayerModel.empty()
      : this.id = "",
        this.color = PlayerColor.Empty,
        this.isBot = false;

  bool get isHuman => !isBot;
}
