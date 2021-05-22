import 'package:go_app/game/client/common/location_dto.dart';
import 'package:go_app/game/client/output/command_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'play_command_dto.g.dart';

@JsonSerializable(createFactory: false)
class PlayCommandDto {
  final CommandDto name = CommandDto.Play;
  final LocationDto location;

  const PlayCommandDto(this.location);

  Map<String, dynamic> toJson() => _$PlayCommandDtoToJson(this);
}
