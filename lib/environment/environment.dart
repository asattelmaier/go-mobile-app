import 'dart:io';

class Environment {
  static const String _ENVIRONMENT_KEY = 'ENV';
  static const String _DEVELOPMENT = 'development';
  static const String _PRODUCTION = 'production';

  Environment();

  bool get isAndroid => Platform.isAndroid;

  bool get isDevelopment => _env == Environment._DEVELOPMENT;

  bool get isProduction => _env == Environment._PRODUCTION;

  String get _env => const String.fromEnvironment(_ENVIRONMENT_KEY);
}
