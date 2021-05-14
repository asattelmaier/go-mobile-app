import 'package:go_app/api/game/common/intersection_dto.dart';
import 'package:go_app/game/board/board_model.dart';

class PositionsModel {
  List<BoardModel> _boards;

  PositionsModel(this._boards);

  BoardModel get board => _boards.first;

  factory PositionsModel.fromDto(List<List<List<IntersectionDto>>> dto) =>
      PositionsModel(dto.map((e) => BoardModel.fromDto(e)).toList());

  List<List<List<IntersectionDto>>> toDto() =>
      _boards.map((board) => board.toDto()).toList();
}
