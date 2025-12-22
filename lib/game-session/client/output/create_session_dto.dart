import 'package:json_annotation/json_annotation.dart';

part 'create_session_dto.g.dart';

@JsonSerializable(createFactory: false)
class CreateSessionDto {
  final String playerId;
  final String? difficulty;

  const CreateSessionDto(this.playerId, [this.difficulty]);

  Map<String, dynamic> toJson() => _$CreateSessionDtoToJson(this);
}
