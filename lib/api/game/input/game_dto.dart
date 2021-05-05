import 'package:json_annotation/json_annotation.dart';

part 'game_dto.g.dart';

enum Player { Black, White }

@JsonSerializable()
class GameDto {
  final Player activePlayer;
  final Player passivePlayer;

  GameDto(this.activePlayer, this.passivePlayer);

  factory GameDto.fromJson(Map<String, dynamic> json) =>
      _$GameDtoFromJson(json);
}
