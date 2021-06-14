import 'package:go_app/game/player/player_color.dart';
import 'package:json_annotation/json_annotation.dart';

part 'player_dto.g.dart';

@JsonSerializable(createToJson: false)
class PlayerDto {
  final String id;
  final PlayerColor color;

  const PlayerDto(this.id, this.color);

  factory PlayerDto.fromJson(Map<String, dynamic> json) =>
      _$PlayerDtoFromJson(json);
}
