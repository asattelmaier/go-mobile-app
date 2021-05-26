import 'package:go_app/game/client/common/game_dto.dart';
import 'package:go_app/game/client/common/intersection_dto.dart';
import 'package:go_app/game/client/common/location_dto.dart';
import 'package:go_app/game/client/common/player_dto.dart';
import 'package:go_app/game/client/common/settings_dto.dart';
import 'package:go_app/game/client/common/state_dto.dart';

GameDto createGame([int rows = 0]) {
  return GameDto(SettingsDto.empty(), PlayerDto.Black, PlayerDto.White, [
    List.generate(
        rows,
        (x) => List.generate(
            rows, (y) => IntersectionDto(LocationDto(x, y), StateDto.Empty)))
  ]);
}
