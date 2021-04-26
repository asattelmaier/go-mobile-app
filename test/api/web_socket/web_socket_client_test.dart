import 'package:flutter_test/flutter_test.dart';
import 'package:go_app/api/game/output/command_dto.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:go_app/api/web_socket/web_socket_client.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'web_socket_client_test.mocks.dart';

@GenerateMocks([IOWebSocketChannel, WebSocketSink])
void main() {
  group('send', () {
    test('sends a message', () {
      final message = 'Some Message';
      final channel = MockIOWebSocketChannel();
      final sink = MockWebSocketSink();
      final webSocketClient = WebSocketClient(channel);

      when(channel.sink).thenReturn(sink);
      when(sink.add(message)).thenReturn((data) => null);
      webSocketClient.send(message);

      verify(sink.add(message)).called(1);
    });

    test('will not send a message if the message is empty', () {
      final message = '';
      final channel = MockIOWebSocketChannel();
      final sink = MockWebSocketSink();
      final webSocketClient = WebSocketClient(channel);

      when(channel.sink).thenReturn(sink);
      webSocketClient.send(message);

      verifyNever(sink.add(message));
    });
  });

  group('sendJson', () {
    test('sends a JSON as string', () {
      final sampleClass = CommandDto(Command.CreateGame, 2);
      final channel = MockIOWebSocketChannel();
      final sink = MockWebSocketSink();
      final webSocketClient = WebSocketClient(channel);

      when(channel.sink).thenReturn(sink);
      when(sink.add(argThat(isA<String>()))).thenReturn((data) => null);
      webSocketClient.sendJson(sampleClass);

      verify(sink.add('''{"name":"CreateGame","size":2}''')).called(1);
    });
  });
}
