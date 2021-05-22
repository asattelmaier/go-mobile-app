import 'package:go_app/configuration/configurations/android_dev.dart';
import 'package:go_app/environment/environment.dart';

class Configuration {
  final String webSocketUrl = 'ws://localhost:8000';

  const Configuration();

  factory Configuration.create(Environment environment) {
    if (environment.isAndroid && environment.isDevelopment) {
      return new AndroidDevConfiguration();
    }

    return new Configuration();
  }
}
