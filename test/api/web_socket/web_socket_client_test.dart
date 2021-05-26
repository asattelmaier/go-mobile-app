import 'package:flutter_test/flutter_test.dart';
import 'package:go_app/game/client/common/settings_dto.dart';
import 'package:go_app/game/client/output/create_command_dto.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
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
      final client = WebSocketClient(channel);

      when(channel.sink).thenReturn(sink);
      when(sink.add(message)).thenReturn((data) => null);
      client.send(message);

      verify(sink.add(message)).called(1);
    });

    test('sends not empty messages', () {
      final message = '';
      final channel = MockIOWebSocketChannel();
      final sink = MockWebSocketSink();
      final client = WebSocketClient(channel);

      when(channel.sink).thenReturn(sink);
      client.send(message);

      verifyNever(sink.add(message));
    });
  });

  group('sendJson', () {
    test('sends JSON', () {
      final channel = MockIOWebSocketChannel();
      final sink = MockWebSocketSink();
      final client = WebSocketClient(channel);
      final command = CreateCommandDto(SettingsDto(2, false));

      when(channel.sink).thenReturn(sink);
      when(sink.add(argThat(isA<String>()))).thenReturn((data) => null);
      client.sendJson(command);

      verify(sink.add('''{"name":"Create","settings":{"boardSize":2,"isSuicideAllowed":false}}''')).called(1);
    });

    test('sends empty JSON', () {
      final channel = MockIOWebSocketChannel();
      final sink = MockWebSocketSink();
      final client = WebSocketClient(channel);

      when(channel.sink).thenReturn(sink);
      when(sink.add(argThat(isA<String>()))).thenReturn((data) => null);
      client.sendJson({});

      verify(sink.add('{}')).called(1);
    });
  });

  group('jsonMessages', () {
    test('returns JSON Messages', () {
      final channel = MockIOWebSocketChannel();
      final client = WebSocketClient(channel);
      final returnStream = (_) => Stream.value('''{"some": "data"}''');

      when(channel.stream).thenAnswer(returnStream);

      client.messages.listen((json) {
        expect(json['some'], 'data');
      });
    });
  });
}
