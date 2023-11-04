import 'package:go_app/configuration/configurations/android_dev.dart';
import 'package:go_app/configuration/configurations/production.dart';
import 'package:go_app/environment/environment.dart';

class Configuration {
  static const _HOST = 'localhost';
  static const _PORT = 8080;
  final Uri backendUrl = Uri(scheme: 'http', host: _HOST, port: _PORT);
  final Uri websocketUrl = Uri(scheme: 'ws', host: _HOST, port: _PORT);

  Configuration();

  factory Configuration.create(Environment environment) {
    if (environment.isAndroid && environment.isDevelopment) {
      return new AndroidDevConfiguration();
    }

    if (environment.isProduction) {
      return new ProductionConfiguration();
    }

    return new Configuration();
  }
}
