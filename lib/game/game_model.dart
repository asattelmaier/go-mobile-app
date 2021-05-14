import 'package:go_app/api/game/common/game_dto.dart';
import 'package:go_app/game/board/board_model.dart';
import 'package:go_app/game/player/player_model.dart';
import 'package:go_app/game/positions/positions_model.dart';

class GameModel {
  final Player activePlayer;
  final Player passivePlayer;
  final PositionsModel positions;

  GameModel(this.activePlayer, this.passivePlayer, this.positions);

  factory GameModel.fromDto(GameDto dto) => GameModel(
      Player.fromDto(dto.activePlayer),
      Player.fromDto(dto.passivePlayer),
      PositionsModel.fromDto(dto.positions));

  GameDto toDto() =>
      GameDto(activePlayer.toDto(), passivePlayer.toDto(), positions.toDto());

  BoardModel get board => positions.board;
}
