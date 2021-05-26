import 'package:go_app/game/client/common/settings_dto.dart';

class SettingsModel {
  final int boardSize;
  final bool isSuicideAllowed;

  const SettingsModel(this.boardSize, this.isSuicideAllowed);

  const SettingsModel.empty()
      : this.boardSize = 0,
        this.isSuicideAllowed = false;

  factory SettingsModel.fromDto(SettingsDto dto) =>
      SettingsModel(dto.boardSize, dto.isSuicideAllowed);

  SettingsDto toDto() => SettingsDto(boardSize, isSuicideAllowed);
}
