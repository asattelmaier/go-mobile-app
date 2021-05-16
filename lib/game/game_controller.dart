import 'dart:async';

import 'package:go_app/api/game/common/game_dto.dart';
import 'package:go_app/api/game/game_client.dart';
import 'package:go_app/game/end_game/end_game_model.dart';
import 'package:go_app/game/game_model.dart';
import 'package:go_app/game/board/intersection/location/location_model.dart';
import 'package:rxdart/rxdart.dart';

class GameController {
  final BehaviorSubject<GameModel> _game;
  final StreamController<EndGameModel> _endGame;
  final GameClient _client;

  factory GameController(GameClient client) {
    // ignore: close_sinks
    BehaviorSubject<GameModel> game = BehaviorSubject();
    // ignore: close_sinks
    StreamController<EndGameModel> endGame = StreamController();

    game.add(GameModel.empty());
    client.game.listen((dto) => game.add(GameModel.fromDto(dto)));
    client.endGame.listen((dto) => endGame.add(EndGameModel.fromDto(dto)));

    return GameController._(client, game, endGame);
  }

  GameController._(this._client, this._game, this._endGame);

  Stream<GameModel> get game => _game.stream;

  Stream<EndGameModel> get endGame => _endGame.stream;

  bool get isPlaying => _game.value.isPlaying;

  create(int size) {
    _client.create(size);
  }

  play(LocationModel location) {
    _client.play(location.toDto(), _gameDto);
  }

  pass() {
    _client.pass(_gameDto);
  }

  close() {
    _client.close();
    _game.close();
    _endGame.close();
  }

  GameDto get _gameDto {
    if (_game.hasValue) {
      return _game.value.toDto();
    }

    return GameDto.empty();
  }
}
