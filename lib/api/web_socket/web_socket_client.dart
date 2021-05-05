import 'dart:convert';
import 'dart:async';

import 'package:web_socket_channel/io.dart';

class WebSocketClient {
  final IOWebSocketChannel _channel;

  WebSocketClient(this._channel);

  Stream<Map<String, dynamic>> get messages => _channel.stream.map(_decodeData);

  void send(String message) {
    if (message.isNotEmpty) {
      _channel.sink.add(message);
    }
  }

  void sendJson(Object object) {
    send(jsonEncode(object));
  }

  void close() {
    _channel.sink.close();
  }

  Map<String, dynamic> _decodeData(dynamic data) {
    return jsonDecode(data);
  }
}
