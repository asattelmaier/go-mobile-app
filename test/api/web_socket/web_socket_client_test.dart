import 'package:flutter_test/flutter_test.dart';
import 'package:go_app/game/client/common/settings_dto.dart';
import 'package:go_app/game/client/output/create_command_dto.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:go_app/api/web_socket/web_socket_client.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_frame.dart';
import 'web_socket_client_test.mocks.dart';

@GenerateMocks([StompClient])
void main() {
  group('send', () {
    test('sends a message', () {
      final destination = '/some/destination';
      final message = 'Some Message';
      final stompClient = MockStompClient();
      final webSocketClient = WebSocketClient(stompClient);

      when(stompClient.send(destination: destination, body: message))
          .thenReturn(null);
      webSocketClient.send(destination, message);

      verify(stompClient.send(destination: destination, body: message))
          .called(1);
    });

    test('sends not empty messages', () {
      final destination = '/some/destination';
      final message = '';
      final stompClient = MockStompClient();
      final webSocketClient = WebSocketClient(stompClient);

      when(stompClient.send(destination: destination, body: message))
          .thenReturn(null);
      webSocketClient.send(destination, message);

      verifyNever(stompClient.send(destination: destination, body: message));
    });

    test('sends without a message', () {
      final destination = '/some/destination';
      final stompClient = MockStompClient();
      final webSocketClient = WebSocketClient(stompClient);

      when(stompClient.send(destination: destination)).thenReturn(null);
      webSocketClient.send(destination);

      verify(stompClient.send(destination: destination)).called(1);
    });
  });

  group('sendJson', () {
    test('sends JSON', () {
      final destination = '/some/destination';
      final stompClient = MockStompClient();
      final webSocketClient = WebSocketClient(stompClient);
      final command = CreateCommandDto(SettingsDto(2, false));
      final expectedMessage =
          '''{"name":"Create","settings":{"boardSize":2,"isSuicideAllowed":false}}''';

      when(stompClient.send(destination: destination, body: expectedMessage))
          .thenReturn(null);
      webSocketClient.sendJson(destination, command);

      verify(stompClient.send(destination: destination, body: expectedMessage))
          .called(1);
    });

    test('sends empty JSON', () {
      final destination = '/some/destination';
      final stompClient = MockStompClient();
      final webSocketClient = WebSocketClient(stompClient);

      when(stompClient.activate()).thenReturn(null);
      when(stompClient.send(destination: destination, body: "{}"))
          .thenReturn(null);
      webSocketClient.sendJson(destination, {});

      verify(stompClient.send(destination: destination, body: "{}")).called(1);
    });
  });

  group('subscribe', () {
    test('returns JSON Messages', () async {
      final destination = '/some/destination';
      final stompClient = MockStompClient();
      final webSocketClient = WebSocketClient(stompClient);
      final returnCallback = (Invocation invocation) {
        final namedArgs = invocation.namedArguments;
        final callback = namedArgs[Symbol('callback')] as Function(StompFrame);
        callback(StompFrame(command: "test", body: '''{"some": "data"}'''));
        return ({Map<String, String>? unsubscribeHeaders}) {};
      };

      when(stompClient.activate()).thenReturn(null);
      when(stompClient.subscribe(
              destination: anyNamed('destination'),
              callback: anyNamed('callback')))
          .thenAnswer(returnCallback);
      final value = await webSocketClient.subscribe(destination).first;

      expect(value['some'], 'data');
    });
  });
}
