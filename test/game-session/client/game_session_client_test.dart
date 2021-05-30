import 'package:flutter_test/flutter_test.dart';
import 'package:go_app/api/web_socket/web_socket_client.dart';
import 'package:go_app/game-session/client/game_session_client.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'game_session_client_test.mocks.dart';

@GenerateMocks([WebSocketClient])
void main() {
  group('GameSessionClient', () {
    test('subscribes to /user/game/session/created', () {
      final webSocketClient = MockWebSocketClient();
      final subscription = "/user/game/session/created";

      when(webSocketClient.subscribe(any)).thenAnswer((_) => Stream.empty());
      GameSessionClient(webSocketClient);

      verify(webSocketClient.subscribe(subscription)).called(1);
    });

    test('subscribes to /user/game/session/joined', () {
      final webSocketClient = MockWebSocketClient();
      final subscription = "/user/game/session/joined";

      when(webSocketClient.subscribe(any)).thenAnswer((_) => Stream.empty());
      GameSessionClient(webSocketClient);

      verify(webSocketClient.subscribe(subscription)).called(1);
    });

    test('subscribes to /user/game/session/player-joined', () {
      final webSocketClient = MockWebSocketClient();
      final subscription = "/user/game/session/player-joined";

      when(webSocketClient.subscribe(any)).thenAnswer((_) => Stream.empty());
      GameSessionClient(webSocketClient);

      verify(webSocketClient.subscribe(subscription)).called(1);
    });
  });
}
