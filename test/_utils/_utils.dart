import 'package:go_app/game/client/common/game_dto.dart';
import 'package:go_app/game/client/common/intersection_dto.dart';
import 'package:go_app/game/client/common/location_dto.dart';
import 'package:go_app/game-session/client/input/player_dto.dart';
import 'package:go_app/game/player/player_color.dart';
import 'package:go_app/game/client/common/settings_dto.dart';
import 'package:go_app/game/client/common/state_dto.dart';

GameDto createGame([int rows = 0]) {
  return GameDto(
      const SettingsDto.empty(),
      const PlayerDto("black", PlayerColor.Black),
      const PlayerDto("white", PlayerColor.White),
      [
    List.generate(
        rows,
        (x) => List.generate(
            rows, (y) => IntersectionDto(LocationDto(x, y), StateDto.Empty)))
  ], false);
}
