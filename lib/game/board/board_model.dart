import 'package:session_server_client/api.dart';
import 'package:go_app/game/board/intersection/intersection_model.dart';

class BoardModel {
  final List<List<IntersectionModel>> intersections;

  const BoardModel(this.intersections);

  const BoardModel.empty() : this.intersections = const [];

  factory BoardModel.fromDto(BoardStateDto dto) => BoardModel(dto.rows
      .map((row) => row.cols.map((col) => IntersectionModel.fromDto(col)).toList())
      .toList());

  BoardStateDto toDto() =>
      BoardStateDto(rows: intersections.map((row) => IntersectionRowDto(cols: row.map((col) => col.toDto()).toList())).toList());

  int get size => intersections.length;

  bool get isEmpty => size == 0;
}
