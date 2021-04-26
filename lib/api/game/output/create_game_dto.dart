import 'package:go_app/api/game/output/command_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'create_game_dto.g.dart';

@JsonSerializable()
class CreateGameDto {
  final CommandDto command;

  CreateGameDto(this.command);

  Map<String, dynamic> toJson() => _$CreateGameDtoToJson(this);
}
