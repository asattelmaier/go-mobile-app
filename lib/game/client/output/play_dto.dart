import 'package:go_app/game/client/common/game_dto.dart';
import 'package:go_app/game/client/output/play_command_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'play_dto.g.dart';

@JsonSerializable(createFactory: false)
class PlayDto {
  final PlayCommandDto command;
  final GameDto game;

  const PlayDto(this.command, this.game);

  Map<String, dynamic> toJson() => _$PlayDtoToJson(this);
}
