import 'dart:async';

import 'package:go_app/api/web_socket/subscriptions/web_socket_subscription.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';

class WebSocketStompSubscription implements WebSocketSubscription {
  final String _destination;
  final StompUnsubscribe _subscription;

  const WebSocketStompSubscription(this._destination, this._subscription);

  @override
  Future<void> close() {
    _subscription();
    return Future.value();
  }

  @override
  bool has(String destination) {
    return destination == _destination;
  }
}
