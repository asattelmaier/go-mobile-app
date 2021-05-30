import 'dart:convert';
import 'dart:async';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';

class WebSocketClient {
  final StompClient _stompClient;
  final List<StreamController> _subscriptions = [];

  WebSocketClient(this._stompClient);

  static Future<WebSocketClient> connect(String url) async {
    final connection = Completer();
    final onConnect = connection.complete;
    final stompClientConfig = StompConfig(url: url, onConnect: onConnect);
    final stompClient = StompClient(config: stompClientConfig);

    stompClient.activate();

    return connection.future.then((value) => new WebSocketClient(stompClient));
  }

  void send(String destination, [String message = '']) {
    if (message.isEmpty) {
      _stompClient.send(destination: destination);
      return;
    }

    _stompClient.send(destination: destination, body: message);
  }

  void sendJson(String destination, Object object) {
    send(destination, jsonEncode(object));
  }

  Stream<Map<String, dynamic>> subscribe(String destination) {
    final subscription = new StreamController<Map<String, dynamic>>();
    _subscriptions.add(subscription);

    _stompClient.subscribe(
      destination: destination,
      callback: (frame) => subscription.add(jsonDecode(frame.body!)),
    );

    return subscription.stream;
  }

  void close() {
    _subscriptions.forEach((subscription) => subscription.close());
  }
}
