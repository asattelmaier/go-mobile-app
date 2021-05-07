import 'package:go_app/api/game/output/create_game_command_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'create_game_dto.g.dart';

@JsonSerializable(createFactory: false)
class CreateGameDto {
  final CreateGameCommandDto command;

  CreateGameDto(this.command);

  Map<String, dynamic> toJson() => _$CreateGameDtoToJson(this);
}
