import 'package:go_app/api/game/input/game_dto.dart';
import 'package:go_app/api/game/output/command_dto.dart';
import 'package:go_app/api/game/output/create_game_dto.dart';
import 'package:go_app/api/web_socket/web_socket_client.dart';

class GameClient {
  final WebSocketClient _client;

  GameClient(this._client);

  createGame(int size) {
    final command = CommandDto(Command.CreateGame, size);
    final dto = CreateGameDto(command);

    _client.sendJson(dto);
  }

  Stream<GameDto> get messages => _client.messages.map(_toGameDto);

  GameDto _toGameDto(Map<String, dynamic> json) {
    return GameDto.fromJson(json);
  }
}
