import 'package:go_app/game/client/common/intersection_dto.dart';
import 'package:go_app/game-session/client/input/player_dto.dart';
import 'package:go_app/game/player/player_color.dart';
import 'package:go_app/game/client/common/settings_dto.dart';
import 'package:go_app/game/player/player_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'game_dto.g.dart';

@JsonSerializable()
class GameDto {
  final SettingsDto settings;
  final PlayerDto activePlayer;
  final PlayerDto passivePlayer;
  final List<List<List<IntersectionDto>>> positions;

  final bool isGameEnded;

  const GameDto(
      this.settings, this.activePlayer, this.passivePlayer, this.positions, this.isGameEnded);

  const GameDto.empty()
      : this.settings = const SettingsDto.empty(),
        this.activePlayer = const PlayerDto(PlayerModel.unknownId, PlayerColor.Black),
        this.passivePlayer = const PlayerDto(PlayerModel.unknownId, PlayerColor.White),
        this.positions = const [
          [[]]
        ],
        this.isGameEnded = false;

  static bool isGameDto(Map<String, dynamic> json) {
    return json['activePlayer'] is Map &&
        json['passivePlayer'] is Map &&
        json['positions'] is List<dynamic>;
  }

  factory GameDto.fromJson(Map<String, dynamic> json) =>
      _$GameDtoFromJson(json);

  Map<String, dynamic> toJson() => _$GameDtoToJson(this);
}
