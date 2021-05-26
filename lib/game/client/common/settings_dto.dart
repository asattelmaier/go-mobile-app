import 'package:json_annotation/json_annotation.dart';

part 'settings_dto.g.dart';

@JsonSerializable()
class SettingsDto {
  final int boardSize;
  final bool isSuicideAllowed;

  const SettingsDto(this.boardSize, this.isSuicideAllowed);

  const SettingsDto.empty()
      : this.boardSize = 0,
        this.isSuicideAllowed = false;

  factory SettingsDto.fromJson(Map<String, dynamic> json) =>
      _$SettingsDtoFromJson(json);

  Map<String, dynamic> toJson() => _$SettingsDtoToJson(this);
}
