import 'package:go_app/api/game/common/game_dto.dart';
import 'package:go_app/api/game/common/intersection_dto.dart';
import 'package:go_app/api/game/common/location_dto.dart';
import 'package:go_app/api/game/common/player_dto.dart';
import 'package:go_app/api/game/common/state_dto.dart';

GameDto createGame([int rows = 0]) {
  return GameDto(PlayerDto.Black, PlayerDto.White, [
    List.generate(
        rows,
        (x) => List.generate(
            rows, (y) => IntersectionDto(LocationDto(x, y), StateDto.Empty)))
  ]);
}
