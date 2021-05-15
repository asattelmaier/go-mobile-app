import 'package:go_app/api/game/common/game_dto.dart';
import 'package:go_app/api/game/output/play_command_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'play_dto.g.dart';

@JsonSerializable(createFactory: false)
class PlayDto {
  final PlayCommandDto command;
  final GameDto game;

  PlayDto(this.command, this.game);

  Map<String, dynamic> toJson() => _$PlayDtoToJson(this);
}
