import 'package:go_app/api/game/common/game_dto.dart';
import 'package:go_app/api/game/game_client.dart';
import 'package:go_app/game/game_model.dart';
import 'package:go_app/game/board/intersection/location/location_model.dart';
import 'package:rxdart/rxdart.dart';

class GameController {
  final BehaviorSubject<GameModel> _game;
  final GameClient _client;

  factory GameController(GameClient client) {
    // ignore: close_sinks
    BehaviorSubject<GameModel> game = BehaviorSubject();

    client.game.listen((dto) => game.add(GameModel.fromDto(dto)));

    return GameController._(client, game);
  }

  GameController._(this._client, this._game);

  Stream<GameModel> get game => _game.stream;

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
  }

  GameDto get _gameDto {
    if (_game.hasValue) {
      return _game.value.toDto();
    }

    return GameDto.empty();
  }
}
