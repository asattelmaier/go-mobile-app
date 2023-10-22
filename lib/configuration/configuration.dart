import 'package:go_app/configuration/configurations/android_dev.dart';
import 'package:go_app/configuration/configurations/production.dart';
import 'package:go_app/environment/environment.dart';

class Configuration {
  final Uri backendUrl = Uri(scheme: 'http', host: 'localhost', port: 8080);

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
