import 'package:go_app/api/game/common/game_dto.dart';
import 'package:go_app/api/game/output/play_stone_command_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'play_stone_dto.g.dart';

@JsonSerializable(createFactory: false)
class PlayStoneDto {
  final PlayStoneCommandDto command;
  final GameDto game;

  PlayStoneDto(this.command, this.game);

  Map<String, dynamic> toJson() => _$PlayStoneDtoToJson(this);
}
