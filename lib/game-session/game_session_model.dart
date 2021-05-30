import 'package:go_app/game-session/client/input/game_session_dto.dart';

class GameSessionModel {
  final String id;

  const GameSessionModel(this.id);

  factory GameSessionModel.fromDto(GameSessionDto dto) {
    return GameSessionModel(dto.id);
  }
}
