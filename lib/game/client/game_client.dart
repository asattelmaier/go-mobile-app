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
  final ValueStream<Map<String, dynamic>> _messages;
  final GameSessionController _gameSessionController;

  GameClient(this._gameSessionController)
      : this._messages = _gameSessionController.messages;

  ValueStream<GameModel> get game {
    return _messages
        .where(_isGameDto)
        .map(_toGameDto)
        .map(_toGame)
        .shareValue();
  }

  ValueStream<EndGameModel> get endGame {
    return _messages
        .where(_isEndGameDto)
        .map(_toEndGameDto)
        .map(_toEndGame)
        .shareValue();
  }

  create(SettingsModel settings) {
    final command = CreateCommandDto(settings.toDto());
    final create = CreateDto(command);

    _gameSessionController.update(create);
  }

  play(LocationModel location, GameModel game) {
    final command = PlayCommandDto(location.toDto());
    final play = PlayDto(command, game.toDto());

    _gameSessionController.update(play);
  }

  pass(GameModel game) {
    final command = PassCommandDto();
    final pass = PassDto(command, game.toDto());

    _gameSessionController.update(pass);
  }

  close() {
    _gameSessionController.close();
  }

  bool _isGameDto(Map<String, dynamic> json) => GameDto.isGameDto(json);

  GameDto _toGameDto(Map<String, dynamic> json) {
    return GameDto.fromJson(json);
  }

  GameModel _toGame(GameDto dto) => GameModel.fromDto(dto);

  bool _isEndGameDto(Map<String, dynamic> json) {
    return EndGameDto.isEndGameDto(json);
  }

  EndGameDto _toEndGameDto(Map<String, dynamic> json) {
    return EndGameDto.fromJson(json);
  }

  EndGameModel _toEndGame(EndGameDto dto) => EndGameModel.fromDto(dto);
}
