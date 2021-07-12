import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:go_app/api/web_socket/subscriptions/web_socket_stomp_subscription.dart';
import 'package:go_app/api/web_socket/subscriptions/web_socket_stream_subscription.dart';
import 'package:go_app/api/web_socket/subscriptions/web_socket_subscription.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';

class WebSocketClient {
  final StompClient _stompClient;
  final List<WebSocketSubscription> _subscriptions = [];

  WebSocketClient(this._stompClient);

  static Future<WebSocketClient> connect(String url) async {
    final connection = Completer();
    final onConnect = connection.complete;
    final stompClientConfig = StompConfig(
        url: url,
        onConnect: onConnect,
        onWebSocketError: onWebSocketError,
        onStompError: onStompError);
    final stompClient = StompClient(config: stompClientConfig);

    stompClient.activate();

    return connection.future.then((value) => new WebSocketClient(stompClient));
  }

  void send(String destination, [String message = '']) {
    if (message.isEmpty) {
      _stompClient.send(destination: destination);
      return;
    }

    // TODO: Send binary messages instead of string message
    _stompClient.send(destination: destination, body: message);
  }

  void sendJson(String destination, Object object) {
    send(destination, jsonEncode(object));
  }

  Stream<Map<String, dynamic>> subscribe(String destination) {
    // ignore: close_sinks
    final subscription = new StreamController<Map<String, dynamic>>();

    final stompSubscription = _stompClient.subscribe(
      destination: destination,
      callback: (frame) => subscription.add(jsonDecode(frame.body!)),
    );

    _subscriptions.add(WebSocketStreamSubscription(destination, subscription));
    // Stomp Subscription is not relevant for actual data, the data will be
    // handled by the Stream Subscription, the Stomp Subscription is only
    // relevant for the connection itself and should also be unsubscribed.
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

  static void onWebSocketError(dynamic message) {
    log("WebSocket Error: ${message.toString()}");
  }

  static void onStompError(StompFrame stompFrame) {
    log("Stomp Error: ${stompFrame.toString()}");
  }
}
