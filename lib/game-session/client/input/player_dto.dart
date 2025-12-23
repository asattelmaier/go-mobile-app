import 'package:go_app/game/player/player_color.dart';
import 'package:json_annotation/json_annotation.dart';

part 'player_dto.g.dart';

@JsonSerializable()
class PlayerDto {
  final String id;
  final PlayerColor color;
  final bool isBot;

  const PlayerDto(this.id, this.color, [this.isBot = false]);

  factory PlayerDto.fromJson(Map<String, dynamic> json) =>
      _$PlayerDtoFromJson(json);

  Map<String, dynamic> toJson() => _$PlayerDtoToJson(this);
}
