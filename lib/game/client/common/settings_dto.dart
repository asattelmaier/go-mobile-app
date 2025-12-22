import 'package:json_annotation/json_annotation.dart';

part 'settings_dto.g.dart';

@JsonSerializable()
class SettingsDto {
  final int boardSize;

  const SettingsDto(this.boardSize);

  const SettingsDto.empty()
      : this.boardSize = 0;

  factory SettingsDto.fromJson(Map<String, dynamic> json) =>
      _$SettingsDtoFromJson(json);

  Map<String, dynamic> toJson() => _$SettingsDtoToJson(this);
}
