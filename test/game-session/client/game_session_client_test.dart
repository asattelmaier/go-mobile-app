import 'package:flutter_test/flutter_test.dart';
import 'package:session_server_client/api.dart';
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
    [WebSocketClient, GameSessionModel, ApiClient, UserModel, UserController])
void main() {
  group('created', () {
    test('subscribes to /user/game/session/created', () {
      final userController = MockUserController();
      final apiClient = MockApiClient();
      final webSocketClient = MockWebSocketClient();
      final subscription = "/user/game/session/created";
      final gameSessionClient =
          GameSessionClient(webSocketClient, apiClient, userController);

      when(webSocketClient.subscribe(subscription))
          .thenAnswer((_) => Stream.empty());
      gameSessionClient.created;

      verify(webSocketClient.subscribe(subscription)).called(1);
    });

    test('returns a game session stream', () async {
      final userController = MockUserController();
      final apiClient = MockApiClient();
      final webSocketClient = MockWebSocketClient();
      final subscription = "/user/game/session/created";
      final json = {"id": "some-id", "players": []};
      final gameSessionClient =
          GameSessionClient(webSocketClient, apiClient, userController);

      when(webSocketClient.subscribe(subscription))
          .thenAnswer((_) => Stream.value(json));
      final gameSession = await gameSessionClient.created.first;

      expect(gameSession.id, "some-id");
    });
  });

  group('terminated', () {
    test('subscribes to /game/session/some-id/terminated', () {
      final userController = MockUserController();
      final apiClient = MockApiClient();
      final webSocketClient = MockWebSocketClient();
      final subscription = "/game/session/some-id/terminated";
      final gameSessionClient =
          GameSessionClient(webSocketClient, apiClient, userController);

      when(webSocketClient.subscribe(subscription))
          .thenAnswer((_) => Stream.empty());
      gameSessionClient.terminated("some-id");

      verify(webSocketClient.subscribe(subscription)).called(1);
    });

    test('returns a game session stream', () async {
      final userController = MockUserController();
      final apiClient = MockApiClient();
      final webSocketClient = MockWebSocketClient();
      final subscription = "/game/session/some-id/terminated";
      final json = {"id": "some-id", "players": []};
      final gameSessionClient =
          GameSessionClient(webSocketClient, apiClient, userController);

      when(webSocketClient.subscribe(subscription))
          .thenAnswer((_) => Stream.value(json));
      final gameSession = await gameSessionClient.terminated("some-id").first;

      expect(gameSession.id, "some-id");
    });
  });

  group('joined', () {
    test('subscribes to /user/game/session/joined', () {
      final userController = MockUserController();
      final apiClient = MockApiClient();
      final webSocketClient = MockWebSocketClient();
      final subscription = "/user/game/session/joined";
      final gameSessionClient =
          GameSessionClient(webSocketClient, apiClient, userController);

      when(webSocketClient.subscribe(subscription))
          .thenAnswer((_) => Stream.empty());
      gameSessionClient.joined;

      verify(webSocketClient.subscribe(subscription)).called(1);
    });

    test('returns a game session stream', () async {
      final userController = MockUserController();
      final apiClient = MockApiClient();
      final webSocketClient = MockWebSocketClient();
      final subscription = "/user/game/session/joined";
      final json = {"id": "some-id", "players": []};
      final gameSessionClient =
          GameSessionClient(webSocketClient, apiClient, userController);

      when(webSocketClient.subscribe(subscription))
          .thenAnswer((_) => Stream.value(json));
      final gameSession = await gameSessionClient.joined.first;

      expect(gameSession.id, "some-id");
    });
  });

  group('playerJoined', () {
    test('subscribes to /user/game/session/player-joined', () {
      final userController = MockUserController();
      final apiClient = MockApiClient();
      final webSocketClient = MockWebSocketClient();
      final subscription = "/game/session/some-id/player-joined";
      final gameSessionClient =
          GameSessionClient(webSocketClient, apiClient, userController);

      when(webSocketClient.subscribe(subscription))
          .thenAnswer((_) => Stream.empty());
      gameSessionClient.playerJoined("some-id");

      verify(webSocketClient.subscribe(subscription)).called(1);
    });

    test('returns a game session stream', () async {
      final userController = MockUserController();
      final apiClient = MockApiClient();
      final webSocketClient = MockWebSocketClient();
      final subscription = "/game/session/id/player-joined";
      final json = {"id": "some-id", "players": []};
      final gameSessionClient =
          GameSessionClient(webSocketClient, apiClient, userController);

      when(webSocketClient.subscribe(subscription))
          .thenAnswer((_) => Stream.value(json));
      final gameSession = await gameSessionClient.playerJoined("id").first;

      expect(gameSession.id, "some-id");
    });
  });

  group('createSession', () {
    test('sends a create session message', () {
      final userController = MockUserController();
      final user = MockUserModel();
      final apiClient = MockApiClient();
      final webSocketClient = MockWebSocketClient();
      final path = "/game/session/create";
      // Generated DTO toJson might include nulls or omit them depending on config.
      // We match generic json structure.
      final gameSessionClient =
          GameSessionClient(webSocketClient, apiClient, userController);

      when(user.isPresent).thenReturn(true);
      when(user.id).thenReturn("some-id");
      when(webSocketClient.send(path)).thenReturn(null);
      gameSessionClient.createSession(user);

      // Verify a JSON is sent. Exact content depends on DTO serialization.
      verify(webSocketClient.sendJson(path, any)).called(1);
    });
  });

  group('joinSession', () {
    test('sends a empty message to /game/session/some-id/join', () {
      final userController = MockUserController();
      final apiClient = MockApiClient();
      final webSocketClient = MockWebSocketClient();
      final path = "/game/session/some-id/join";
      final gameSessionClient =
          GameSessionClient(webSocketClient, apiClient, userController);

      when(webSocketClient.send(path)).thenReturn(null);
      gameSessionClient.joinSession("some-id");

      verify(webSocketClient.send(path)).called(1);
    });
  });

  group('sendMove', () {
    test('sends a message to /game/session/some-id/update', () {
      final userController = MockUserController();
      final apiClient = MockApiClient();
      final webSocketClient = MockWebSocketClient();
      final path = "/game/session/some-id/update";
      final move = DeviceMove(x: 1, y: 1, type: DeviceMoveTypeEnum.PLAY);
      final gameSessionClient =
          GameSessionClient(webSocketClient, apiClient, userController);

      when(webSocketClient.sendJson(path, any)).thenReturn(null);
      gameSessionClient.sendMove("some-id", move);

      verify(webSocketClient.sendJson(path, any)).called(1);
    });
  });

  group('gameUpdates', () {
    test('returns mapped GameDto', () async {
      final userController = MockUserController();
      final apiClient = MockApiClient();
      final webSocketClient = MockWebSocketClient();
      final updatedSubscription = "/game/session/some-id/updated";
      final gameDtoJson = {
        "settings": {"boardSize": 9},
        "activePlayer": {"id": "b", "color": "BLACK"},
        "passivePlayer": {"id": "w", "color": "WHITE"},
        "positions": [],
        "isGameEnded": false
      };
      final gameSessionClient =
          GameSessionClient(webSocketClient, apiClient, userController);

      when(webSocketClient.subscribe(updatedSubscription))
          .thenAnswer((_) => Stream.value(gameDtoJson));

      final gameDto = await gameSessionClient.gameUpdates("some-id").first;

      expect(gameDto.settings?.boardSize, 9);
    });
  });

  group('dispose', () {
    test('disposes all id dependent subscriptions', () async {
      final userController = MockUserController();
      final apiClient = MockApiClient();
      final destinations = [
        "/game/session/some-id/terminate",
        "/game/session/some-id/terminated",
        "/game/session/some-id/update",
        "/game/session/some-id/updated",
        "/game/session/some-id/endgame",
        "/game/session/some-id/join",
        "/game/session/some-id/player-joined",
      ];
      final webSocketClient = MockWebSocketClient();
      final gameSessionClient =
          GameSessionClient(webSocketClient, apiClient, userController);

      when(webSocketClient.dispose(destinations))
          .thenAnswer((_) => Future.value());
      await gameSessionClient.dispose("some-id");

      verify(webSocketClient.dispose(destinations)).called(1);
    });
  });
}
