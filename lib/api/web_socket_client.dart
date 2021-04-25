import 'package:web_socket_channel/io.dart';

class WebSocketClient {
  final IOWebSocketChannel _channel;

  WebSocketClient(this._channel);

  Stream<dynamic> get stream => _channel.stream;

  void send(String message) {
    if (message.isNotEmpty) {
      _channel.sink.add(message);
    }
  }

  void close() {
    _channel.sink.close();
  }
}
