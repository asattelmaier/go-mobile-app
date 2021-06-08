import 'package:async/async.dart';
import 'package:go_app/game/board/board_model.dart';
import 'package:go_app/game/board/intersection/location/location_model.dart';
import 'package:go_app/game/client/game_client.dart';
import 'package:go_app/game/end_game/end_game_model.dart';
import 'package:go_app/game/game_model.dart';
import 'package:go_app/game/player/player_model.dart';
import 'package:go_app/game/settings/settings_model.dart';
import 'package:rxdart/rxdart.dart';

class GameController {
  final GameClient _client;
  final ValueStream<GameModel> _gameStream;
  final ValueStream<EndGameModel> _endGameStream;

  GameController(this._client)
      : this._gameStream = _client.game,
        this._endGameStream = _client.endGame;

  Stream get updateStream => StreamGroup.merge([_gameStream, _endGameStream]);

  bool get isPlaying => _game.isPlaying;

  bool get isGameOver => endGame.created > _game.created;

  EndGameModel get endGame {
    if (_endGameStream.hasValue) {
      return _endGameStream.value;
    }

    return EndGameModel.empty();
  }

  BoardModel get board => _game.board;

  PlayerModel get activePlayer => _game.activePlayer;

  void create(int boardSize, bool isSuicideAllowed) {
    final settings = SettingsModel(boardSize, isSuicideAllowed);

    _client.create(settings);
  }

  void play(LocationModel location) {
    if (!isGameOver) {
      _client.play(location, _game);
    }
  }

  void pass() {
    _client.pass(_game);
  }

  void close() {
    _client.close();
  }

  GameModel get _game {
    if (_gameStream.hasValue) {
      return _gameStream.value;
    }

    return GameModel.empty();
  }
}
