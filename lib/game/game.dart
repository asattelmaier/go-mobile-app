import 'dart:async';

import 'package:go_app/api/game/common/game_dto.dart';
import 'package:go_app/api/game/game_client.dart';
import 'package:go_app/game/location.dart';
import 'package:go_app/game/player.dart';
import 'package:go_app/game/positions.dart';
import 'package:rxdart/rxdart.dart';

import 'board.dart';

class Game {
  BehaviorSubject<GameDto> _game;
  GameClient _client;

  factory Game(GameClient client) {
    // ignore: close_sinks
    BehaviorSubject<GameDto> game = BehaviorSubject();

    game.addStream(client.game);

    return Game._(client, game);
  }

  create(int size) {
    _client.createGame(size);
  }

  playStone(Location location) {
    _client.playStone(location.toDto(), _toDto());
  }

  pass() {
    _client.pass(_toDto());
  }

  close() {
    _client.close();
    _game.close();
  }

  Stream<Player> get activePlayer =>
      _game.map((dto) => Player.fromDto(dto.activePlayer));

  Stream<Player> get passivePlayer =>
      _game.map((dto) => Player.fromDto(dto.passivePlayer));

  Stream<Board> get board => _game
      .map((dto) => Positions.fromDto(dto.positions))
      .map((positions) => positions.board);

  Game._(this._client, this._game);

  GameDto _toDto() {
    if (!_game.hasValue) {
      return GameDto.empty();
    }

    return _game.value;
  }
}
