import 'package:go_app/configuration/configuration.dart';

class ProductionConfiguration extends Configuration {
  final Uri backendUrl = Uri(
      scheme: 'https',
      host: 'go-session-server-qknfj7fqza-ew.a.run.app',
      port: 443);
}
