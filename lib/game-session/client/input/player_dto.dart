import 'package:json_annotation/json_annotation.dart';

part 'player_dto.g.dart';

@JsonSerializable(createToJson: false)
class PlayerDto {
  final String id;

  const PlayerDto(this.id);

  factory PlayerDto.fromJson(Map<String, dynamic> json) =>
      _$PlayerDtoFromJson(json);
}
