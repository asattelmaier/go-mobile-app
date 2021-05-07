import 'package:go_app/api/game/common/location_dto.dart';
import 'package:go_app/api/game/output/command_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'play_stone_command_dto.g.dart';

@JsonSerializable(createFactory: false)
class PlayStoneCommandDto {
  CommandDto name = CommandDto.PlayStone;
  LocationDto location;

  PlayStoneCommandDto(this.location);

  Map<String, dynamic> toJson() => _$PlayStoneCommandDtoToJson(this);
}
