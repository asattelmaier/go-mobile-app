import 'package:go_app/api/game/common/intersection_dto.dart';
import 'package:go_app/game/intersection.dart';

class Board {
  List<List<Intersection>> _intersections;

  Board(this._intersections);

  Board.empty() : this._intersections = [];

  factory Board.fromDto(List<List<IntersectionDto>> dto) => Board(
      dto.map((e) => e.map((e) => Intersection.fromDto(e)).toList()).toList());

  List<List<IntersectionDto>> toDto() =>
      _intersections.map((e) => e.map((e) => e.toDto()).toList()).toList();

  int get rows => _intersections.length;
}
