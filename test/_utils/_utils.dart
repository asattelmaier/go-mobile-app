import 'package:go_app/api/game/common/game_dto.dart';
import 'package:go_app/api/game/common/player_dto.dart';

GameDto createGame() {
  return GameDto(PlayerDto.Black, PlayerDto.White, [
    [[]]
  ]);
}
