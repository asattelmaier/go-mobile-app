import 'package:go_app/api/game/common/intersection_dto.dart';
import 'package:go_app/game/board.dart';

class Positions {
  List<Board> _boards;

  Positions(this._boards);

  Board get board => _boards.first;

  factory Positions.fromDto(List<List<List<IntersectionDto>>> dto) =>
      Positions(dto.map((e) => Board.fromDto(e)).toList());

  List<List<List<IntersectionDto>>> toDto() =>
      _boards.map((board) => board.toDto()).toList();
}
