import 'package:go_app/api/game/input/intersection_dto.dart';
import 'package:go_app/api/game/input/player_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'game_dto.g.dart';

@JsonSerializable(createToJson: false)
class GameDto {
  final PlayerDto activePlayer;
  final PlayerDto passivePlayer;
  final List<List<List<IntersectionDto>>> positions;

  GameDto(this.activePlayer, this.passivePlayer, this.positions);

  factory GameDto.fromJson(Map<String, dynamic> json) =>
      _$GameDtoFromJson(json);
}
