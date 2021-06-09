import 'package:go_app/game-session/client/input/player_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'game_session_dto.g.dart';

@JsonSerializable(createToJson: false)
class GameSessionDto {
  final String id;
  final List<PlayerDto> players;

  const GameSessionDto(this.id, this.players);

  factory GameSessionDto.fromJson(Map<String, dynamic> json) =>
      _$GameSessionDtoFromJson(json);
}
