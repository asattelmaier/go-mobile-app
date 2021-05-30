import 'package:flutter_test/flutter_test.dart';
import 'package:go_app/game-session/client/game_session_client_destination.dart';
import 'package:go_app/game-session/game_session_model.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rxdart/rxdart.dart';
import 'game_session_client_destination_test.mocks.dart';

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
      final destination = GameSessionClientDestination.playerJoined;

      expect(destination, "/user/game/session/player-joined");
    });
  });

  group('create', () {
    test('returns /game/session/create', () {
      final subject = BehaviorSubject<MockGameSessionModel>();
      final gameSession = MockGameSessionModel();
      final destination = GameSessionClientDestination(subject);

      subject.add(gameSession);

      expect(destination.create, "/game/session/create");
      subject.close();
    });
  });

  group('join', () {
    test('returns /game/session/{gameSessionId}/join', () {
      final subject = BehaviorSubject<MockGameSessionModel>();
      final gameSession = MockGameSessionModel();
      final destination = GameSessionClientDestination(subject);

      subject.add(gameSession);
      when(gameSession.id).thenReturn("some-id");

      expect(destination.join, "/game/session/some-id/join");
      subject.close();
    });
  });

  group('update', () {
    test('returns /game/session/{gameSessionId}/update', () {
      final subject = BehaviorSubject<MockGameSessionModel>();
      final gameSession = MockGameSessionModel();
      final destination = GameSessionClientDestination(subject);

      subject.add(gameSession);
      when(gameSession.id).thenReturn("some-id");

      expect(destination.update, "/game/session/some-id/update");
      subject.close();
    });
  });

  group('updated', () {
    test('returns /game/session/{gameSessionId}/updated', () {
      final subject = BehaviorSubject<MockGameSessionModel>();
      final gameSession = MockGameSessionModel();
      final destination = GameSessionClientDestination(subject);

      subject.add(gameSession);
      when(gameSession.id).thenReturn("some-id");

      expect(destination.updated, "/game/session/some-id/updated");
      subject.close();
    });
  });
}
