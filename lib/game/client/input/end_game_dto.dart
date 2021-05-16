import 'package:go_app/game/client/common/player_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'end_game_dto.g.dart';

@JsonSerializable(createToJson: false)
class EndGameDto {
  final int score;
  final List<PlayerDto> winner;

  EndGameDto(this.score, this.winner);

  static bool isEndGameDto(Map<String, dynamic> json) {
    return json['score'] is int && json['winner'] is List<dynamic>;
  }

  factory EndGameDto.fromJson(Map<String, dynamic> json) =>
      _$EndGameDtoFromJson(json);
}
