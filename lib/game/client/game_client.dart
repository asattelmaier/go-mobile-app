import 'package:session_server_client/api.dart';
import 'package:go_app/game-session/game_session_controller.dart';
import 'package:go_app/game/end_game/end_game_model.dart';
import 'package:go_app/game/game_model.dart';
import 'package:go_app/game/board/intersection/location/location_model.dart';

class GameClient {
  final GameSessionController _controller;

  GameClient(this._controller);

  Stream<GameModel> get game => _controller.gameUpdates
      .map((dto) => GameModel.fromDto(dto));

  Stream<EndGameModel> get endGame => _controller.gameEnded
      .map((dto) => EndGameModel.fromDto(dto));


  void play(LocationModel location, GameModel game) {
    if (_controller.currentPlayer.color == game.activePlayer.color) {
      final move = DeviceMove(
          type: DeviceMoveTypeEnum.PLAY,
          x: location.x,
          y: location.y);
      _controller.sendMove(move);
    }
  }

  void pass(GameModel game) {
    if (_controller.currentPlayer.color == game.activePlayer.color) {
      final move = DeviceMove(
          type: DeviceMoveTypeEnum.PASS);
      _controller.sendMove(move);
    }
  }
}
