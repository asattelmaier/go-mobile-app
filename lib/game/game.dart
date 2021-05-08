import 'package:go_app/api/game/common/game_dto.dart';
import 'package:go_app/api/game/game_client.dart';
import 'package:go_app/game/location.dart';
import 'package:go_app/game/player.dart';
import 'package:go_app/game/positions.dart';

import 'board.dart';

class Game {
  GameClient _client;

  Game(this._client);

  create(int size) {
    _client.createGame(size);
  }

  playStone(Location location) async {
    GameDto game = await _toDto();

    _client.playStone(location.toDto(), game);
  }

  pass() async {
    GameDto game = await _toDto();

    _client.pass(game);
  }

  Stream<Player> get activePlayer =>
      _client.messages.map((dto) => Player.fromDto(dto.activePlayer));

  Stream<Player> get passivePlayer =>
      _client.messages.map((dto) => Player.fromDto(dto.passivePlayer));

  Stream<Board> get board => _positions.map((positions) => positions.board);

  Stream<Positions> get _positions =>
      _client.messages.map((dto) => Positions.fromDto(dto.positions));

  Future<GameDto> _toDto() async {
    Positions positions = await _positions.last;
    Player activePlayer = await this.activePlayer.last;
    Player passivePlayer = await this.passivePlayer.last;

    return GameDto(
        activePlayer.toDto(), passivePlayer.toDto(), positions.toDto());
  }
}
