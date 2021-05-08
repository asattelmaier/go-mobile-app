import 'package:go_app/api/game/common/game_dto.dart';
import 'package:go_app/api/game/output/pass_command_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'pass_dto.g.dart';

@JsonSerializable(createFactory: false)
class PassDto {
  final PassCommandDto command;
  final GameDto game;

  PassDto(this.command, this.game);

  Map<String, dynamic> toJson() => _$PassDtoToJson(this);
}
