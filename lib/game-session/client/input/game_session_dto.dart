import 'package:json_annotation/json_annotation.dart';

part 'game_session_dto.g.dart';

@JsonSerializable(createToJson: false)
class GameSessionDto {
  final String id;

  const GameSessionDto(this.id);

  factory GameSessionDto.fromJson(Map<String, dynamic> json) =>
      _$GameSessionDtoFromJson(json);
}
