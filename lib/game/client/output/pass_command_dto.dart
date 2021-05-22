import 'package:go_app/game/client/output/command_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'pass_command_dto.g.dart';

@JsonSerializable(createFactory: false)
class PassCommandDto {
  final CommandDto name = CommandDto.Pass;

  const PassCommandDto();

  Map<String, dynamic> toJson() => _$PassCommandDtoToJson(this);
}
