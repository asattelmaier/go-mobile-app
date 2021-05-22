import 'package:go_app/game/board/board_model.dart';
import 'package:go_app/game/client/common/game_dto.dart';
import 'package:go_app/game/player/player_color.dart';
import 'package:go_app/game/player/player_model.dart';
import 'package:go_app/game/positions/positions_model.dart';

class GameModel {
  final PlayerModel activePlayer;
  final PlayerModel passivePlayer;
  final PositionsModel positions;
  final bool isPlaying;
  final int created;

  GameModel(this.activePlayer, this.passivePlayer, this.positions)
      : this.isPlaying = true,
        this.created = DateTime.now().millisecondsSinceEpoch;

  const GameModel.empty()
      : this.activePlayer = const PlayerModel(PlayerColor.Black),
        this.passivePlayer = const PlayerModel(PlayerColor.White),
        this.positions = const PositionsModel.empty(),
        this.isPlaying = false,
        this.created = 0;

  factory GameModel.fromNullable(GameModel? game) {
    if (game == null) {
      return GameModel.empty();
    }

    return game;
  }

  factory GameModel.fromDto(GameDto dto) => GameModel(
      PlayerModel.fromDto(dto.activePlayer),
      PlayerModel.fromDto(dto.passivePlayer),
      PositionsModel.fromDto(dto.positions));

  GameDto toDto() =>
      GameDto(activePlayer.toDto(), passivePlayer.toDto(), positions.toDto());

  BoardModel get board => positions.board;
}
