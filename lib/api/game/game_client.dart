import 'package:go_app/api/game/common/game_dto.dart';
import 'package:go_app/api/game/common/location_dto.dart';
import 'package:go_app/api/game/output/create_game_command_dto.dart';
import 'package:go_app/api/game/output/create_game_dto.dart';
import 'package:go_app/api/game/output/play_stone_command_dto.dart';
import 'package:go_app/api/game/output/play_stone_dto.dart';
import 'package:go_app/api/web_socket/web_socket_client.dart';

class GameClient {
  final WebSocketClient _client;

  GameClient(this._client);

  createGame(int size) {
    final command = CreateGameCommandDto(size);
    final createGame = CreateGameDto(command);

    _client.sendJson(createGame);
  }

  playStone(LocationDto location, GameDto game) {
    final command = PlayStoneCommandDto(location);
    final playStone = PlayStoneDto(command, game);

    _client.sendJson(playStone);
  }

  Stream<GameDto> get messages => _client.messages.map(_toGameDto);

  GameDto _toGameDto(Map<String, dynamic> json) {
    return GameDto.fromJson(json);
  }
}
