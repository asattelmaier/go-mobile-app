import 'package:go_app/configuration/configuration.dart';

class AndroidDevConfiguration extends Configuration {
  static const _HOST = '10.0.2.2';
  static const _PORT = 8080;
  final Uri backendUrl = Uri(scheme: 'http', host: _HOST, port: _PORT);
  final Uri websocketUrl = Uri(scheme: 'ws', host: _HOST, port: _PORT);
}
