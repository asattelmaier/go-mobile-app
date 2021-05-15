import 'package:go_app/api/game/common/game_dto.dart';
import 'package:go_app/game/board/board_model.dart';
import 'package:go_app/game/player/player_color.dart';
import 'package:go_app/game/player/player_model.dart';
import 'package:go_app/game/positions/positions_model.dart';

class GameModel {
  final PlayerModel activePlayer;
  final PlayerModel passivePlayer;
  final PositionsModel positions;

  GameModel(this.activePlayer, this.passivePlayer, this.positions);

  factory GameModel.fromDto(GameDto dto) => GameModel(
      PlayerModel.fromDto(dto.activePlayer),
      PlayerModel.fromDto(dto.passivePlayer),
      PositionsModel.fromDto(dto.positions));

  factory GameModel.fromNullable(GameModel? game) {
    if (game == null) {
      return GameModel._createEmptyGame();
    }

    return game;
  }

  GameDto toDto() =>
      GameDto(activePlayer.toDto(), passivePlayer.toDto(), positions.toDto());

  BoardModel get board => positions.board;

  static GameModel _createEmptyGame() => GameModel(
      PlayerModel(PlayerColor.Black),
      PlayerModel(PlayerColor.White),
      PositionsModel.empty());
}
