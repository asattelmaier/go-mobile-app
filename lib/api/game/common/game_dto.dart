import 'package:go_app/api/game/common/intersection_dto.dart';
import 'package:go_app/api/game/common/player_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'game_dto.g.dart';

@JsonSerializable()
class GameDto {
  final PlayerDto activePlayer;
  final PlayerDto passivePlayer;
  final List<List<List<IntersectionDto>>> positions;

  GameDto(this.activePlayer, this.passivePlayer, this.positions);

  GameDto.empty()
      : this.activePlayer = PlayerDto.Black,
        this.passivePlayer = PlayerDto.White,
        this.positions = [
          [[]]
        ];

  static bool isGameDto(Map<String, dynamic> json) {
    return json['activePlayer'] is String &&
        json['passivePlayer'] is String &&
        json['positions'] is List<dynamic>;
  }

  factory GameDto.fromJson(Map<String, dynamic> json) =>
      _$GameDtoFromJson(json);

  Map<String, dynamic> toJson() => _$GameDtoToJson(this);
}
