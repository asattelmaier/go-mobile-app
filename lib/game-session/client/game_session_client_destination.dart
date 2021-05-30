import 'package:go_app/game-session/game_session_model.dart';
import 'package:rxdart/rxdart.dart';

class GameSessionClientDestination {
  static const _USER_PREFIX = "/user";
  static const _PREFIX = "/game/session";
  static const _CREATE = "/create";
  static const _JOIN = "/join";
  static const _UPDATE = "/update";
  static const _CREATED = "/created";
  static const _JOINED = "/joined";
  static const _PLAYER_JOINED = "/player-joined";
  static const _UPDATED = "/updated";
  BehaviorSubject<GameSessionModel> _gameSession;

  GameSessionClientDestination(this._gameSession);

  static String get created {
    return _createUserDestination(_CREATED);
  }

  static String get joined {
    return _createUserDestination(_JOINED);
  }

  static String get playerJoined {
    return _createUserDestination(_PLAYER_JOINED);
  }

  String get create {
    return _createDestination(_CREATE);
  }

  String get join {
    return _createDestination(_JOIN, _gameSessionId);
  }

  String get update {
    return _createDestination(_UPDATE, _gameSessionId);
  }

  String get updated {
    return _createDestination(_UPDATED, _gameSessionId);
  }

  String get _gameSessionId {
    if (_gameSession.hasValue) {
      return _gameSession.value.id;
    }

    return "";
  }

  static String _createUserDestination(String destination) {
    return "$_USER_PREFIX${_createDestination(destination)}";
  }

  static String _createDestination(String destination, [String id = ""]) {
    if (id.isEmpty) {
      return "$_PREFIX$destination";
    }

    return "$_PREFIX/$id$destination";
  }
}
