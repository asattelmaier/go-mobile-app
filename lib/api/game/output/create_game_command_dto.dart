import 'package:go_app/api/game/output/command_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'create_game_command_dto.g.dart';

@JsonSerializable(createFactory: false)
class CreateGameCommandDto {
  CommandDto name = CommandDto.CreateGame;
  int size;

  CreateGameCommandDto(this.size);

  Map<String, dynamic> toJson() => _$CreateGameCommandDtoToJson(this);
}
