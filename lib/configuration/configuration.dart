import 'package:go_app/configuration/configurations/android_dev.dart';
import 'package:go_app/configuration/configurations/production.dart';
import 'package:go_app/environment/environment.dart';

class Configuration {
  static const _HOST = String.fromEnvironment('BACKEND_HOST', defaultValue: 'localhost');
  static const _PORT = 8080;
  
  // These cannot be final fields initialized with non-const statics in a const constructor context if the class was const, 
  // but Configuration() is not const constructor.
  // actually, let's just make them Getters to be safe and simple.
  Uri get backendUrl => Uri(scheme: 'http', host: _HOST, port: _PORT);
  Uri get websocketUrl => Uri(scheme: 'ws', host: _HOST, port: _PORT);

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
