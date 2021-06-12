import 'package:go_app/game/board/board_model.dart';
import 'package:go_app/game/board/intersection/location/location_model.dart';
import 'package:go_app/game/client/game_client.dart';
import 'package:go_app/game/end_game/end_game_model.dart';
import 'package:go_app/game/game_model.dart';
import 'package:go_app/game/player/player_model.dart';
import 'package:go_app/game/settings/settings_model.dart';

class GameController {
  final GameClient _client;
  final GameModel _game;
  final EndGameModel _endGame;

  GameController(this._client, this._game, this._endGame);

  bool get isPlaying => _game.isPlaying;

  bool get isGameOver => endGame.created > _game.created;

  EndGameModel get endGame => _endGame;

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
}
