import 'package:flutter_test/flutter_test.dart';
import 'package:go_app/api/http/http_client.dart';
import 'package:go_app/api/http_headers/http_headers_builder.dart';
import 'package:go_app/api/web_socket/web_socket_client.dart';
import 'package:go_app/game-session/client/game_session_client.dart';
import 'package:go_app/game-session/game_session_model.dart';
import 'package:go_app/user/user_controller.dart';
import 'package:go_app/user/user_model.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'game_session_client_test.mocks.dart';

@GenerateMocks(
    [WebSocketClient, GameSessionModel, HttpClient, UserModel, UserController])
void main() {
  group('created', () {
    test('subscribes to /user/game/session/created', () {
      final userController = MockUserController();
      final httpClient = MockHttpClient();
      final webSocketClient = MockWebSocketClient();
      final subscription = "/user/game/session/created";
      final gameSessionClient =
          GameSessionClient(webSocketClient, httpClient, userController);

      when(webSocketClient.subscribe(subscription))
          .thenAnswer((_) => Stream.empty());
      gameSessionClient.created;

      verify(webSocketClient.subscribe(subscription)).called(1);
    });

    test('returns a game session stream', () async {
      final userController = MockUserController();
      final httpClient = MockHttpClient();
      final webSocketClient = MockWebSocketClient();
      final subscription = "/user/game/session/created";
      final json = {"id": "some-id", "players": []};
      final gameSessionClient =
          GameSessionClient(webSocketClient, httpClient, userController);

      when(webSocketClient.subscribe(subscription))
          .thenAnswer((_) => Stream.value(json));
      final gameSession = await gameSessionClient.created.first;

      expect(gameSession.id, "some-id");
    });
  });

  group('terminated', () {
    test('subscribes to /game/session/some-id/terminated', () {
      final userController = MockUserController();
      final httpClient = MockHttpClient();
      final webSocketClient = MockWebSocketClient();
      final subscription = "/game/session/some-id/terminated";
      final gameSessionClient =
          GameSessionClient(webSocketClient, httpClient, userController);

      when(webSocketClient.subscribe(subscription))
          .thenAnswer((_) => Stream.empty());
      gameSessionClient.terminated("some-id");

      verify(webSocketClient.subscribe(subscription)).called(1);
    });

    test('returns a game session stream', () async {
      final userController = MockUserController();
      final httpClient = MockHttpClient();
      final webSocketClient = MockWebSocketClient();
      final subscription = "/game/session/some-id/terminated";
      final json = {"id": "some-id", "players": []};
      final gameSessionClient =
          GameSessionClient(webSocketClient, httpClient, userController);

      when(webSocketClient.subscribe(subscription))
          .thenAnswer((_) => Stream.value(json));
      final gameSession = await gameSessionClient.terminated("some-id").first;

      expect(gameSession.id, "some-id");
    });
  });

  group('joined', () {
    test('subscribes to /user/game/session/joined', () {
      final userController = MockUserController();
      final httpClient = MockHttpClient();
      final webSocketClient = MockWebSocketClient();
      final subscription = "/user/game/session/joined";
      final gameSessionClient =
          GameSessionClient(webSocketClient, httpClient, userController);

      when(webSocketClient.subscribe(subscription))
          .thenAnswer((_) => Stream.empty());
      gameSessionClient.joined;

      verify(webSocketClient.subscribe(subscription)).called(1);
    });

    test('returns a game session stream', () async {
      final userController = MockUserController();
      final httpClient = MockHttpClient();
      final webSocketClient = MockWebSocketClient();
      final subscription = "/user/game/session/joined";
      final json = {"id": "some-id", "players": []};
      final gameSessionClient =
          GameSessionClient(webSocketClient, httpClient, userController);

      when(webSocketClient.subscribe(subscription))
          .thenAnswer((_) => Stream.value(json));
      final gameSession = await gameSessionClient.joined.first;

      expect(gameSession.id, "some-id");
    });
  });

  group('playerJoined', () {
    test('subscribes to /user/game/session/player-joined', () {
      final userController = MockUserController();
      final httpClient = MockHttpClient();
      final webSocketClient = MockWebSocketClient();
      final subscription = "/game/session/some-id/player-joined";
      final gameSessionClient =
          GameSessionClient(webSocketClient, httpClient, userController);

      when(webSocketClient.subscribe(subscription))
          .thenAnswer((_) => Stream.empty());
      gameSessionClient.playerJoined("some-id");

      verify(webSocketClient.subscribe(subscription)).called(1);
    });

    test('returns a game session stream', () async {
      final userController = MockUserController();
      final httpClient = MockHttpClient();
      final webSocketClient = MockWebSocketClient();
      final subscription = "/game/session/id/player-joined";
      final json = {"id": "some-id", "players": []};
      final gameSessionClient =
          GameSessionClient(webSocketClient, httpClient, userController);

      when(webSocketClient.subscribe(subscription))
          .thenAnswer((_) => Stream.value(json));
      final gameSession = await gameSessionClient.playerJoined("id").first;

      expect(gameSession.id, "some-id");
    });
  });

  group('createSession', () {
    test('sends a empty message to /game/session/create', () {
      final userController = MockUserController();
      final user = MockUserModel();
      final httpClient = MockHttpClient();
      final webSocketClient = MockWebSocketClient();
      final path = "/game/session/create";
      final json = {"playerId": "some-id"};
      final gameSessionClient =
          GameSessionClient(webSocketClient, httpClient, userController);

      when(user.isPresent).thenReturn(true);
      when(user.id).thenReturn("some-id");
      when(webSocketClient.send(path)).thenReturn(null);
      gameSessionClient.createSession(user);

      verify(webSocketClient.sendJson(path, json)).called(1);
    });

    test('sends no message if user is not present', () {
      final userController = MockUserController();
      final user = MockUserModel();
      final httpClient = MockHttpClient();
      final webSocketClient = MockWebSocketClient();
      final path = "/game/session/create";
      final gameSessionClient =
          GameSessionClient(webSocketClient, httpClient, userController);

      when(user.isPresent).thenReturn(false);
      gameSessionClient.createSession(user);

      verifyNever(webSocketClient.sendJson(path, any));
    });
  });

  group('joinSession', () {
    test('sends a empty message to /game/session/some-id/join', () {
      final userController = MockUserController();
      final httpClient = MockHttpClient();
      final webSocketClient = MockWebSocketClient();
      final path = "/game/session/some-id/join";
      final gameSessionClient =
          GameSessionClient(webSocketClient, httpClient, userController);

      when(webSocketClient.send(path)).thenReturn(null);
      gameSessionClient.joinSession("some-id");

      verify(webSocketClient.send(path)).called(1);
    });
  });

  group('updateSession', () {
    test('sends a message to /game/session/some-id/update', () {
      final userController = MockUserController();
      final httpClient = MockHttpClient();
      final webSocketClient = MockWebSocketClient();
      final path = "/game/session/some-id/update";
      final json = {"some": "message"};
      final gameSessionClient =
          GameSessionClient(webSocketClient, httpClient, userController);

      when(webSocketClient.sendJson(path, json)).thenReturn(null);
      gameSessionClient.updateSession("some-id", json);

      verify(webSocketClient.sendJson(path, json)).called(1);
    });
  });

  group('messages', () {
    test('returns messages /game/session/some-id/updated', () async {
      final userController = MockUserController();
      final httpClient = MockHttpClient();
      final webSocketClient = MockWebSocketClient();
      final subscription = "/game/session/some-id/updated";
      final json = {"some": "message"};
      final gameSessionClient =
          GameSessionClient(webSocketClient, httpClient, userController);

      when(webSocketClient.subscribe(subscription))
          .thenAnswer((_) => Stream.value(json));
      final message = await gameSessionClient.messages("some-id").first;

      expect(message, json);
    });
  });

  group('getPendingSessions', () {
    test('returns all pending sessions', () async {
      final userController = MockUserController();
      final httpClient = MockHttpClient();
      final webSocketClient = MockWebSocketClient();
      final token = "some-token";
      final headers = HttpHeadersBuilder.token(token).build();
      final response = Future.value([
        {"id": "some-id", "players": []}
      ]);
      final gameSessionClient =
          GameSessionClient(webSocketClient, httpClient, userController);

      when(userController.accessToken).thenReturn(token);
      when(httpClient.get('/game/session/pending', headers))
          .thenAnswer((_) => response);
      final pendingSessions = await gameSessionClient.getPendingSessions();

      expect(pendingSessions.length, 1);
    });

    test('returns no pending sessions if request fails', () async {
      final userController = MockUserController();
      final httpClient = MockHttpClient();
      final webSocketClient = MockWebSocketClient();
      final gameSessionClient =
          GameSessionClient(webSocketClient, httpClient, userController);

      when(httpClient.get('/game/session/pending')).thenThrow('Some Error');
      final pendingSessions = await gameSessionClient.getPendingSessions();

      expect(pendingSessions.length, 0);
    });
  });

  group('dispose', () {
    test('disposes all id dependent subscriptions', () async {
      final userController = MockUserController();
      final httpClient = MockHttpClient();
      final destinations = [
        "/game/session/some-id/terminate",
        "/game/session/some-id/terminated",
        "/game/session/some-id/update",
        "/game/session/some-id/updated",
        "/game/session/some-id/join",
        "/game/session/some-id/player-joined",
      ];
      final webSocketClient = MockWebSocketClient();
      final gameSessionClient =
          GameSessionClient(webSocketClient, httpClient, userController);

      when(webSocketClient.dispose(destinations))
          .thenAnswer((_) => Future.value());
      await gameSessionClient.dispose("some-id");

      verify(webSocketClient.dispose(destinations)).called(1);
    });
  });
}
