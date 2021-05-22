import 'package:go_app/game/client/output/create_command_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'create_dto.g.dart';

@JsonSerializable(createFactory: false)
class CreateDto {
  final CreateCommandDto command;

  const CreateDto(this.command);

  Map<String, dynamic> toJson() => _$CreateDtoToJson(this);
}
