import 'package:session_server_client/api.dart';
import 'package:go_app/game/board/board_model.dart';
import 'package:go_app/game/player/player_color.dart';
import 'package:go_app/game/player/player_model.dart';
import 'package:go_app/game/positions/positions_model.dart';
import 'package:go_app/game/settings/settings_model.dart';

class GameModel {
  final SettingsModel settings;
  final PlayerModel activePlayer;
  final PlayerModel passivePlayer;
  final PositionsModel positions;
  final bool isPlaying;
  final int created;
  final bool isGameEnded;

  GameModel(this.settings, this.activePlayer, this.passivePlayer,
      this.positions, [this.isGameEnded = false])
      : this.isPlaying = !isGameEnded,
        this.created = DateTime.now().millisecondsSinceEpoch;

  const GameModel.empty()
      : this.settings = const SettingsModel.empty(),
        this.activePlayer = const PlayerModel(PlayerModel.unknownId, PlayerColor.Black),
        this.passivePlayer = const PlayerModel(PlayerModel.unknownId, PlayerColor.White),
        this.positions = const PositionsModel.empty(),
        this.isPlaying = false,
        this.isGameEnded = false,
        this.created = 0;

  factory GameModel.fromNullable(GameModel? game) {
    if (game == null) {
      return GameModel.empty();
    }

    return game;
  }

  factory GameModel.fromDto(GameDto dto) => GameModel(
      SettingsModel.fromDto(dto.settings!),
      PlayerModel.fromDto(dto.activePlayer!),
      PlayerModel.fromDto(dto.passivePlayer!),
      PositionsModel.fromDto(dto.positions),
      dto.isGameEnded ?? false);

  GameDto toDto() => GameDto(settings: settings.toDto(), activePlayer: activePlayer.toDto(),
      passivePlayer: passivePlayer.toDto(), positions: positions.toDto(), isGameEnded: isGameEnded);

  BoardModel get board => positions.board;
}
