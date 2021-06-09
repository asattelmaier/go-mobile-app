import 'package:go_app/game-session/client/input/player_dto.dart';

class PlayerModel {
  final String id;

  const PlayerModel(this.id);

  factory PlayerModel.fromDto(PlayerDto dto) {
    return PlayerModel(dto.id);
  }

  const PlayerModel.empty() : this.id = "";
}
