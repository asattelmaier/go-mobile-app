import 'package:go_app/game/client/output/command_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'create_command_dto.g.dart';

@JsonSerializable(createFactory: false)
class CreateCommandDto {
  final CommandDto name = CommandDto.Create;
  final int size;

  const CreateCommandDto(this.size);

  Map<String, dynamic> toJson() => _$CreateCommandDtoToJson(this);
}
