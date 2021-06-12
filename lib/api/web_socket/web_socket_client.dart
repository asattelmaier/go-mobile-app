import 'dart:async';
import 'dart:convert';

import 'package:go_app/api/web_socket/subscriptions/web_socket_stomp_subscription.dart';
import 'package:go_app/api/web_socket/subscriptions/web_socket_stream_subscription.dart';
import 'package:go_app/api/web_socket/subscriptions/web_socket_subscription.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';

class WebSocketClient {
  final StompClient _stompClient;
  final List<WebSocketSubscription> _subscriptions = [];

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

    final stompSubscription = _stompClient.subscribe(
      destination: destination,
      callback: (frame) => subscription.add(jsonDecode(frame.body!)),
    );

    _subscriptions.add(WebSocketStreamSubscription(destination, subscription));
    _subscriptions
        .add(WebSocketStompSubscription(destination, stompSubscription));

    return subscription.stream;
  }

  Future<void> dispose(List<String> destinations) {
    return Future.wait(_subscriptions
        .where((subscription) =>
            destinations.any((destination) => subscription.has(destination)))
        .map((subscription) => subscription.close()));
  }
}
