import 'package:go_app/game-session/client/input/game_session_dto.dart';
import 'package:go_app/game-session/player/player_model.dart';

class GameSessionModel {
  final String id;
  final List<PlayerModel> players;

  const GameSessionModel(this.id, this.players);

  factory GameSessionModel.fromDto(GameSessionDto dto) {
    final players = dto.players.map((player) {
      return PlayerModel.fromDto(player);
    }).toList();

    return GameSessionModel(dto.id, players);
  }

  const GameSessionModel.empty()
      : this.id = "",
        this.players = const [];

  bool get isPending => players.length == 1;
}
