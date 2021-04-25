import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:go_app/api/web_socket_client.dart';
import 'web_socket_client_test.mocks.dart';

void main() {
  group('send', () {
    test('sends a message', () {
      final message = 'Some Message';
      final channel = MockIOWebSocketChannel();
      final webSocketClient = WebSocketClient(channel);

      webSocketClient.send(message);

      verify(channel.sink.add(message)).called(1);
    });

    test('will not sends a message if the message is empty', () {
      final message = '';
      final channel = MockIOWebSocketChannel();
      final webSocketClient = WebSocketClient(channel);

      webSocketClient.send(message);

      verifyNever(channel.sink.add(message));
    });
  });
}
