import 'package:session_server_client/api.dart';

class SettingsModel {
  final int boardSize;

  const SettingsModel(this.boardSize);

  const SettingsModel.empty()
      : this.boardSize = 0;

  factory SettingsModel.fromDto(SettingsDto dto) =>
      SettingsModel(dto.boardSize ?? 19);

  SettingsDto toDto() => SettingsDto(boardSize: boardSize);
}
