import 'package:go_app/game-session/game_session_controller.dart';
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
  final GameSessionController _gameSessionController;
  
  late final ValueStream<GameModel> game;
  late final ValueStream<EndGameModel> endGame;

  GameClient(this._gameSessionController) {
    game = _gameSessionController.messages
        .where(_isGameDto)
        .map(_toGameDto)
        .map(GameModel.fromDto)
        .shareValue();

    endGame = _gameSessionController.messages
        .where(_isEndGameDto)
        .map(_toEndGameDto)
        .map(EndGameModel.fromDto)
        .shareValue();
  }

  void create(SettingsModel settings) {
    final command = CreateCommandDto(settings.toDto());
    final create = CreateDto(command);
    _gameSessionController.updateSession(create);
  }

  void play(LocationModel location, GameModel game) {
    final command = PlayCommandDto(location.toDto());
    final play = PlayDto(command, game.toDto());
    _gameSessionController.updateSession(play);
  }

  void pass(GameModel game) {
    final command = PassCommandDto();
    final pass = PassDto(command, game.toDto());
    _gameSessionController.updateSession(pass);
  }

  bool _isGameDto(Map<String, dynamic> json) => GameDto.isGameDto(json);

  GameDto _toGameDto(Map<String, dynamic> json) {
    try {
      return GameDto.fromJson(json);
    } catch (e, stack) {
      print("GAME_CLIENT ERROR: Failed to parse GameDto: $e");
      print(stack);
      rethrow;
    }
  }

  bool _isEndGameDto(Map<String, dynamic> json) => EndGameDto.isEndGameDto(json);

  EndGameDto _toEndGameDto(Map<String, dynamic> json) {
    try {
      return EndGameDto.fromJson(json);
    } catch (e, stack) {
      print("GAME_CLIENT ERROR: Failed to parse EndGameDto: $e");
      print(stack);
      rethrow;
    }
  }
}
