import 'package:go_app/game-session/client/input/player_dto.dart';
import 'package:go_app/game/player/player_model.dart';

class WinnerModel {
  final List<PlayerModel> _players;

  const WinnerModel(this._players);

  const WinnerModel.empty() : this._players = const [];

  bool get isDrawn => hasWhiteWon && hasBlackWon;

  bool get hasWhiteWon => _players.any((player) => player.isWhite);

  bool get hasBlackWon => _players.any((player) => player.isBlack);

  bool get hasWinner => hasWhiteWon || hasBlackWon;

  factory WinnerModel.fromDto(List<PlayerDto> dto) =>
      WinnerModel(dto.map((player) => PlayerModel.fromDto(player)).toList());
}
