import 'package:session_server_client/api.dart';

GameDto createGame([int rows = 0]) {
  return GameDto(
      settings: SettingsDto(boardSize: rows),
      activePlayer: PlayerDto(id: "black", color: "BLACK"),
      passivePlayer: PlayerDto(id: "white", color: "WHITE"),
      positions: [
        BoardStateDto(rows: List.generate(
            rows,
            (x) => IntersectionRowDto(cols: List.generate(
                rows, (y) => IntersectionDto(location: LocationDto(x: x, y: y), state: IntersectionDtoStateEnum.empty)))))
      ],
      isGameEnded: false);
}
