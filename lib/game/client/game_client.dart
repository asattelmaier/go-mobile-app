import 'dart:async';

import 'package:go_app/api/web_socket/web_socket_client.dart';
import 'package:go_app/game/board/intersection/location/location_model.dart';
import 'package:go_app/game/client/common/game_dto.dart';
import 'package:go_app/game/client/input/end_game_dto.dart';
import 'package:go_app/game/client/output/create_command_dto.dart';
import 'package:go_app/game/client/output/create_dto.dart';
import 'package:go_app/game/client/output/pass_command_dto.dart';
import 'package:go_app/game/client/output/pass_dto.dart';
import 'package:go_app/game/client/output/play_command_dto.dart';
import 'package:go_app/game/client/output/play_dto.dart';
import 'package:go_app/game/end_game/end_game_model.dart';
import 'package:go_app/game/game_model.dart';
import 'package:go_app/game/settings/settings_model.dart';
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

  create(SettingsModel settings) {
    final command = CreateCommandDto(settings.toDto());
    final create = CreateDto(command);

    _client.sendJson(create);
  }

  play(LocationModel location, GameModel game) {
    final command = PlayCommandDto(location.toDto());
    final play = PlayDto(command, game.toDto());

    _client.sendJson(play);
  }

  pass(GameModel game) {
    final command = PassCommandDto();
    final pass = PassDto(command, game.toDto());

    _client.sendJson(pass);
  }

  close() {
    _client.close();
    _messages.close();
  }

  Stream<GameModel> get game =>
      _messages.where(_isGameDto).map(_toGameDto).map(_toGame);

  Stream<EndGameModel> get endGame =>
      _messages.where(_isEndGameDto).map(_toEndGameDto).map(_toEndGame);

  GameClient._(this._client, this._messages);

  bool _isGameDto(Map<String, dynamic> json) => GameDto.isGameDto(json);

  GameDto _toGameDto(Map<String, dynamic> json) => GameDto.fromJson(json);

  GameModel _toGame(GameDto dto) => GameModel.fromDto(dto);

  bool _isEndGameDto(Map<String, dynamic> json) =>
      EndGameDto.isEndGameDto(json);

  EndGameDto _toEndGameDto(Map<String, dynamic> json) =>
      EndGameDto.fromJson(json);

  EndGameModel _toEndGame(EndGameDto dto) => EndGameModel.fromDto(dto);
}
