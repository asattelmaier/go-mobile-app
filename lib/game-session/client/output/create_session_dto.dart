import 'package:json_annotation/json_annotation.dart';

part 'create_session_dto.g.dart';

@JsonSerializable(createFactory: false)
class CreateSessionDto {
  final String playerId;
  final String? difficulty;
  final int? boardSize;

  const CreateSessionDto(this.playerId, [this.difficulty, this.boardSize]);

  Map<String, dynamic> toJson() => _$CreateSessionDtoToJson(this);
}
