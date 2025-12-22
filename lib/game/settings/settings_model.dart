import 'package:go_app/game/client/common/settings_dto.dart';

class SettingsModel {
  final int boardSize;

  const SettingsModel(this.boardSize);

  const SettingsModel.empty()
      : this.boardSize = 0;

  factory SettingsModel.fromDto(SettingsDto dto) =>
      SettingsModel(dto.boardSize);

  SettingsDto toDto() => SettingsDto(boardSize);
}
