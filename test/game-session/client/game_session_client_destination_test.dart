import 'package:flutter_test/flutter_test.dart';
import 'package:go_app/game-session/client/game_session_client_destination.dart';
import 'package:go_app/game-session/game_session_model.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks([GameSessionModel])
void main() {
  group('created', () {
    test('returns /user/game/session/created', () {
      final destination = GameSessionClientDestination.created;

      expect(destination, "/user/game/session/created");
    });
  });

  group('joined', () {
    test('returns /user/game/session/joined', () {
      final destination = GameSessionClientDestination.joined;

      expect(destination, "/user/game/session/joined");
    });
  });

  group('playerJoined', () {
    test('returns /user/game/session/player-joined', () {
      final destination = GameSessionClientDestination();

      final playerJoined = destination.playerJoined("some-id");

      expect(playerJoined, "/game/session/some-id/player-joined");
    });
  });

  group('create', () {
    test('returns /game/session/create', () {
      final destination = GameSessionClientDestination();

      expect(destination.create, "/game/session/create");
    });
  });

  group('join', () {
    test('returns /game/session/{gameSessionId}/join', () {
      final destination = GameSessionClientDestination();

      expect(destination.join("some-id"), "/game/session/some-id/join");
    });
  });

  group('update', () {
    test('returns /game/session/{gameSessionId}/update', () {
      final destination = GameSessionClientDestination();

      expect(destination.update("some-id"), "/game/session/some-id/update");
    });
  });

  group('updated', () {
    test('returns /game/session/{gameSessionId}/updated', () {
      final destination = GameSessionClientDestination();

      expect(destination.updated("some-id"), "/game/session/some-id/updated");
    });
  });
}
