import 'package:go_app/configuration/configuration.dart';

class AndroidDevConfiguration extends Configuration {
  final Uri backendUrl = Uri(scheme: 'http', host: '10.0.2.2', port: 8080);
}
