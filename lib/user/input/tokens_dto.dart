import 'package:json_annotation/json_annotation.dart';

part 'tokens_dto.g.dart';

@JsonSerializable(createToJson: false)
class TokensDto {
  final String refreshToken;
  final String accessToken;

  const TokensDto(this.refreshToken, this.accessToken);

  factory TokensDto.fromJson(Map<String, dynamic> json) =>
      _$TokensDtoFromJson(json);
}
