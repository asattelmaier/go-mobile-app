import 'package:go_app/api/game/common/player_dto.dart';
import 'package:go_app/game/player/player_model.dart';

class WinnerModel {
  final List<PlayerModel> _players;

  WinnerModel(this._players);

  bool get isDrawn => hasWhiteWon && hasBlackWon;

  bool get hasWhiteWon => _players.any((player) => player.isWhite);

  bool get hasBlackWon => _players.any((player) => player.isBlack);

  @override
  String toString() {
    if (isDrawn) {
      return 'Drawn';
    }

    if (hasWhiteWon) {
      return 'White';
    }

    return 'Black';
  }

  factory WinnerModel.fromDto(List<PlayerDto> dto) =>
      WinnerModel(dto.map((player) => PlayerModel.fromDto(player)).toList());
}
