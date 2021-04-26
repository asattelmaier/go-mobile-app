import 'package:json_annotation/json_annotation.dart';

part 'command_dto.g.dart';

enum Command { CreateGame, PlayStone, Pass }

@JsonSerializable()
class CommandDto {
  final Command name;
  final int size;

  CommandDto(this.name, this.size);

  factory CommandDto.fromJson(Map<String, dynamic> json) =>
      _$CommandDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CommandDtoToJson(this);
}
