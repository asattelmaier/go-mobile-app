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
  StompClient? _stompClient;
  final Uri _url;
  final List<WebSocketSubscription> _subscriptions = [];

  WebSocketClient(this._url);

  Future<void> connect(Map<String, String> headers) {
    final connection = Completer();
    final onConnect = connection.complete;
    final stompClientConfig = StompConfig(
      url: _url.toString(),
      onConnect: onConnect,
      onWebSocketError: onWebSocketError,
      onStompError: onStompError,
      webSocketConnectHeaders: headers,
    );

    _stompClient = StompClient(config: stompClientConfig);
    _stompClient?.activate();

    return connection.future;
  }

  void send(String destination, [String message = '']) {
    if (message.isEmpty) {
      _stompClient?.send(destination: destination);
      return;
    }

    // TODO: Send binary messages instead of string message
    _stompClient?.send(destination: destination, body: message);
  }

  void sendJson(String destination, Object object) {
    send(destination, jsonEncode(object));
  }

  Stream<Map<String, dynamic>> subscribe(String destination) {
    // ignore: close_sinks
    final subscription = new StreamController<Map<String, dynamic>>();

    final stompSubscription = _stompClient?.subscribe(
      destination: destination,
      callback: (frame) {
        // TODO: The API should send only binary messages
        final body = frame.body ?? String.fromCharCodes(frame.binaryBody ?? []);

        subscription.add(jsonDecode(body));
      },
    );

    _subscriptions.add(WebSocketStreamSubscription(destination, subscription));
    // Stomp Subscription is not relevant for actual data, the data will be
    // handled by the Stream Subscription, the Stomp Subscription is only
    // relevant for the connection itself and should also be unsubscribed.
    if (stompSubscription != null) {
      _subscriptions
          .add(WebSocketStompSubscription(destination, stompSubscription));
    }

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
