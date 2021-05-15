import 'package:go_app/api/game/output/command_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'create_command_dto.g.dart';

@JsonSerializable(createFactory: false)
class CreateCommandDto {
  final CommandDto name = CommandDto.Create;
  final int size;

  CreateCommandDto(this.size);

  Map<String, dynamic> toJson() => _$CreateCommandDtoToJson(this);
}
