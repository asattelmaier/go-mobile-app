import 'package:mockito/mockito.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/src/channel.dart';

class MockWebSocketSink extends Mock implements WebSocketSink {}

class MockIOWebSocketChannel extends Mock implements IOWebSocketChannel {
  // ignore: close_sinks
  MockWebSocketSink sink = MockWebSocketSink();
}