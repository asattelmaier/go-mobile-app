import 'package:go_app/api/game/common/game_dto.dart';
import 'package:go_app/api/game/common/location_dto.dart';
import 'package:go_app/api/game/input/end_game_dto.dart';
import 'package:go_app/api/game/output/create_game_command_dto.dart';
import 'package:go_app/api/game/output/create_game_dto.dart';
import 'package:go_app/api/game/output/pass_command_dto.dart';
import 'package:go_app/api/game/output/pass_dto.dart';
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

  pass(GameDto game) {
    final command = PassCommandDto();
    final pass = PassDto(command, game);

    _client.sendJson(pass);
  }

  Stream<GameDto> get game => _messages.where(_isGameDto).map(_toGameDto);

  Stream<EndGameDto> get endGame =>
      _messages.where(_isEndGameDto).map(_toEndGameDto);

  Stream<Map<String, dynamic>> get _messages => _client.messages;

  bool _isGameDto(Map<String, dynamic> json) => GameDto.isGameDto(json);

  GameDto _toGameDto(Map<String, dynamic> json) => GameDto.fromJson(json);

  bool _isEndGameDto(Map<String, dynamic> json) =>
      EndGameDto.isEndGameDto(json);

  EndGameDto _toEndGameDto(Map<String, dynamic> json) =>
      EndGameDto.fromJson(json);
}
