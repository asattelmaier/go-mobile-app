class GameSessionClientDestination {
  static const _USER_PREFIX = "/user";
  static const _PREFIX = "/game/session";
  static const _CREATE = "/create";
  static const _JOIN = "/join";
  static const _TERMINATE = "/terminate";
  static const _UPDATE = "/update";
  static const _CREATED = "/created";
  static const _TERMINATED = "/terminated";
  static const _JOINED = "/joined";
  static const _PLAYER_JOINED = "/player-joined";
  static const _UPDATED = "/updated";

  const GameSessionClientDestination();

  static String get created {
    return _createUserDestination(_CREATED);
  }

  String terminated(String gameSessionId) {
    return _createDestination(_TERMINATED, gameSessionId);
  }

  static String get joined {
    return _createUserDestination(_JOINED);
  }

  String playerJoined(String gameSessionId) {
    return _createDestination(_PLAYER_JOINED, gameSessionId);
  }

  String get create {
    return _createDestination(_CREATE);
  }

  String terminate(String gameSessionId) {
    return _createDestination(_TERMINATE, gameSessionId);
  }

  String join(String gameSessionId) {
    return _createDestination(_JOIN, gameSessionId);
  }

  String update(String gameSessionId) {
    return _createDestination(_UPDATE, gameSessionId);
  }

  String updated(String gameSessionId) {
    return _createDestination(_UPDATED, gameSessionId);
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
