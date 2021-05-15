import 'dart:async';

import 'package:go_app/api/game/common/game_dto.dart';
import 'package:go_app/api/game/common/location_dto.dart';
import 'package:go_app/api/game/input/end_game_dto.dart';
import 'package:go_app/api/game/output/create_command_dto.dart';
import 'package:go_app/api/game/output/create_dto.dart';
import 'package:go_app/api/game/output/pass_command_dto.dart';
import 'package:go_app/api/game/output/pass_dto.dart';
import 'package:go_app/api/game/output/play_command_dto.dart';
import 'package:go_app/api/game/output/play_dto.dart';
import 'package:go_app/api/web_socket/web_socket_client.dart';
import 'package:rxdart/rxdart.dart';

class GameClient {
  final BehaviorSubject<Map<String, dynamic>> _messages;
  final WebSocketClient _client;

  factory GameClient(WebSocketClient webSocketClient) {
    // ignore: close_sinks
    BehaviorSubject<Map<String, dynamic>> messages = BehaviorSubject();

    messages.addStream(webSocketClient.messages);

    return GameClient._(webSocketClient, messages);
  }

  create(int size) {
    final command = CreateCommandDto(size);
    final create = CreateDto(command);

    _client.sendJson(create);
  }

  play(LocationDto location, GameDto game) {
    final command = PlayCommandDto(location);
    final play = PlayDto(command, game);

    _client.sendJson(play);
  }

  pass(GameDto game) {
    final command = PassCommandDto();
    final pass = PassDto(command, game);

    _client.sendJson(pass);
  }

  close() {
    _client.close();
    _messages.close();
  }

  Stream<GameDto> get game => _messages.where(_isGameDto).map(_toGameDto);

  Stream<EndGameDto> get endGame =>
      _messages.where(_isEndGameDto).map(_toEndGameDto);

  GameClient._(this._client, this._messages);

  bool _isGameDto(Map<String, dynamic> json) => GameDto.isGameDto(json);

  GameDto _toGameDto(Map<String, dynamic> json) => GameDto.fromJson(json);

  bool _isEndGameDto(Map<String, dynamic> json) =>
      EndGameDto.isEndGameDto(json);

  EndGameDto _toEndGameDto(Map<String, dynamic> json) =>
      EndGameDto.fromJson(json);
}
