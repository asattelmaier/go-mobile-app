import 'package:go_app/game/board/board_model.dart';
import 'package:go_app/game/client/common/intersection_dto.dart';

class PositionsModel {
  List<BoardModel> _boards;

  PositionsModel(this._boards);

  PositionsModel.empty() : this._boards = [BoardModel.empty()];

  BoardModel get board => _boards.first;

  factory PositionsModel.fromDto(List<List<List<IntersectionDto>>> dto) =>
      PositionsModel(dto.map((e) => BoardModel.fromDto(e)).toList());

  List<List<List<IntersectionDto>>> toDto() =>
      _boards.map((board) => board.toDto()).toList();
}
