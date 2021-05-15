import 'package:go_app/api/game/output/create_command_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'create_dto.g.dart';

@JsonSerializable(createFactory: false)
class CreateDto {
  final CreateCommandDto command;

  CreateDto(this.command);

  Map<String, dynamic> toJson() => _$CreateDtoToJson(this);
}
