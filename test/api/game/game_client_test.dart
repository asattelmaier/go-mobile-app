import 'package:flutter_test/flutter_test.dart';
import 'package:go_app/api/game/game_client.dart';
import 'package:go_app/api/game/output/create_game_dto.dart';
import 'package:go_app/api/web_socket/web_socket_client.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'game_client_test.mocks.dart';

@GenerateMocks([WebSocketClient])
void main() {
  group('createGame', () {
    test('creates a new game with size of five', () {
      final webSocketClient = MockWebSocketClient();
      final client = GameClient(webSocketClient);
      final isSizeFive =
          predicate<CreateGameDto>((dto) => dto.command.size == 5);

      client.createGame(5);

      verify(webSocketClient.sendJson(argThat(isSizeFive))).called(1);
    });
  });
}
