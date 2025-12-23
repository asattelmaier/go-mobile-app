import 'package:go_app/game/board/board_model.dart';
import 'package:go_app/game/board/intersection/location/location_model.dart';
import 'package:go_app/game/client/game_client.dart';
import 'package:go_app/game/end_game/end_game_model.dart';
import 'package:go_app/game/game_model.dart';
import 'package:go_app/game/player/player_model.dart';
import 'package:go_app/game/settings/settings_model.dart';
import 'package:go_app/game-session/player/session_player_model.dart';

class GameController {
  final GameClient _client;
  final SessionPlayerModel player;
  final GameModel _game;
  final EndGameModel _endGame;

  GameController(this._client, this.player, this._game, this._endGame);

  bool get isPlaying => _game.isPlaying;

  bool get isPlayersTurn => player.color == _game.activePlayer.color;

  bool get isGameOver => _game.isGameEnded;

  bool get shouldCreateGame => !isPlaying && !_game.isGameEnded && isPlayersTurn;

  EndGameModel get endGame => _endGame;

  BoardModel get board => _game.board;

  PlayerModel get activePlayer => _game.activePlayer;

  void create(SettingsModel settings) {
    _client.create(settings);
  }

  void play(LocationModel location) {
    if (!isGameOver && isPlayersTurn) {
      _client.play(location, _game);
    }
  }

  void pass() {
    if (isPlayersTurn) {
      _client.pass(_game);
    }
  }
}
