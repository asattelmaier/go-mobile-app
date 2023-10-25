import 'package:json_annotation/json_annotation.dart';

part 'create_session_dto.g.dart';

@JsonSerializable(createFactory: false)
class CreateSessionDto {
  final String playerId;

  const CreateSessionDto(this.playerId);

  Map<String, dynamic> toJson() => _$CreateSessionDtoToJson(this);
}
