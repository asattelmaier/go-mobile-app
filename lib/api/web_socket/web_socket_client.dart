import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:go_app/api/web_socket/subscriptions/web_socket_stomp_subscription.dart';
import 'package:go_app/api/web_socket/subscriptions/web_socket_stream_subscription.dart';
import 'package:go_app/api/web_socket/subscriptions/web_socket_subscription.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';

class WebSocketClient {
  StompClient? _stompClient;
  final Uri _url;
  final List<WebSocketSubscription> _subscriptions = [];

  Completer<void> _connectionCompleter = Completer<void>();

  WebSocketClient(this._url);

  Future<void> connect(Map<String, String> headers) {
    if (_stompClient != null && _stompClient!.connected) {
       log('WebSocketClient: Already connected');
    }

    // Reset completer if it was already completed (re-connection scenario)
    if (_connectionCompleter.isCompleted) {
      _connectionCompleter = Completer<void>();
    }

    _stompClient = StompClient(
      config: StompConfig(
        url: _url.toString(), // Keep _url.toString() as per original
        onConnect: (frame) {
          log('WebSocketClient: Connected!');
          if (!_connectionCompleter.isCompleted) {
            _connectionCompleter.complete();
          }
        },
        onWebSocketError: (dynamic error) =>
            log('WebSocketClient: Error: $error'),
        onStompError: onStompError, 
        stompConnectHeaders: headers,
        webSocketConnectHeaders: headers,
      ),
    );

    _stompClient!.activate();
    return _connectionCompleter.future;
  }

  void send(String destination, [String message = '']) {
    if (_stompClient == null) {
       log('WebSocketClient: ERROR - _stompClient is null, cannot send!');
       return;
    }
    if (!_stompClient!.connected) {
       log('WebSocketClient: ERROR - _stompClient is not connected, cannot send!');
    }
    
    if (message.isEmpty) {
      _stompClient?.send(destination: destination);
      return;
    }

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
        if (frame.body != null) {
          final json = jsonDecode(frame.body!);
          subscription.add(json);
        }
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

    subscription.onCancel = () {
      stompSubscription?.call();
    };

    return subscription.stream;
  }

  Future<void> dispose(List<String> destinations) {
    return Future.wait(_subscriptions
        .where((subscription) =>
            destinations.any((destination) => subscription.has(destination)))
        .map((subscription) => subscription.close()));
  }

  void disconnect() {
    for (var sub in _subscriptions) {
      sub.close();
    }
    _subscriptions.clear();
    _stompClient?.deactivate();
  }

  static void onWebSocketError(dynamic message) {
    log("WebSocket Error: ${message.toString()}");
  }

  static void onStompError(StompFrame stompFrame) {
    log("Stomp Error: ${stompFrame.toString()}");
  }
}
