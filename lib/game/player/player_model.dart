import 'package:session_server_client/api.dart';
import 'package:go_app/game/player/player_color.dart';

class PlayerModel {
  static const String unknownId = "unknown";
  final String id;
  final PlayerColor color;
  final bool isBot;

  const PlayerModel(this.id, this.color, [this.isBot = false]);

  factory PlayerModel.fromDto(PlayerDto dto) {
    final color = PlayerColor.values.firstWhere(
        (e) => e.name.toUpperCase() == (dto.color ?? "").toUpperCase(),
        orElse: () => PlayerColor.Empty);

    return PlayerModel(dto.id ?? unknownId, color, dto.isBot ?? false);
  }

  PlayerDto toDto() {
    return PlayerDto(
        id: id, color: color.name.toUpperCase(), isBot: isBot);
  }

  bool get isBlack => color == PlayerColor.Black;

  bool get isWhite => color == PlayerColor.White;
}
