import 'package:session_server_client/api.dart';
import 'package:go_app/game/board/board_model.dart';

class PositionsModel {
  final List<BoardModel> _boards;

  const PositionsModel(this._boards);

  const PositionsModel.empty() : this._boards = const [BoardModel.empty()];

  BoardModel get board => _boards.first;

  factory PositionsModel.fromDto(List<BoardStateDto> dto) =>
      PositionsModel(dto.map((e) => BoardModel.fromDto(e)).toList());

  List<BoardStateDto> toDto() =>
      _boards.map((board) => board.toDto()).toList();
}
