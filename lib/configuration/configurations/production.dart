import 'package:go_app/configuration/configuration.dart';

class ProductionConfiguration extends Configuration {
  static const _HOST = 'go-session-server-qknfj7fqza-ew.a.run.app';
  static const _PORT = 443;
  final Uri backendUrl = Uri(scheme: 'https', host: _HOST, port: _PORT);
  final Uri websocketUrl = Uri(scheme: 'wss', host: _HOST, port: _PORT);
}
