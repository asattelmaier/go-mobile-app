import 'dart:async';

import 'package:go_app/api/web_socket/subscriptions/web_socket_subscription.dart';

class WebSocketStreamSubscription implements WebSocketSubscription {
  final String _destination;
  final StreamController<Map<String, dynamic>> _subscription;

  const WebSocketStreamSubscription(this._destination, this._subscription);

  @override
  Future<void> close() {
    return _subscription.close();
  }

  @override
  bool has(String destination) {
    return destination == _destination;
  }
}
