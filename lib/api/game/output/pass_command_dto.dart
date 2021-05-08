import 'package:go_app/api/game/output/command_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'pass_command_dto.g.dart';

@JsonSerializable(createFactory: false)
class PassCommandDto {
  CommandDto name = CommandDto.Pass;

  PassCommandDto();

  Map<String, dynamic> toJson() => _$PassCommandDtoToJson(this);
}
