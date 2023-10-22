import 'package:flutter_test/flutter_test.dart';
import 'package:go_app/configuration/configuration.dart';
import 'package:go_app/configuration/configurations/android_dev.dart';
import 'package:go_app/configuration/configurations/production.dart';
import 'package:go_app/environment/environment.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'configuration_test.mocks.dart';

@GenerateMocks([Environment])
void main() {
  group('create', () {
    test('creates a android dev configuration', () {
      final environment = MockEnvironment();

      when(environment.isAndroid).thenReturn(true);
      when(environment.isDevelopment).thenReturn(true);
      when(environment.isProduction).thenReturn(false);
      final configuration = Configuration.create(environment);

      expect(configuration, isA<AndroidDevConfiguration>());
    });

    test('creates a default configuration', () {
      final environment = MockEnvironment();

      when(environment.isAndroid).thenReturn(false);
      when(environment.isDevelopment).thenReturn(true);
      when(environment.isProduction).thenReturn(false);
      final configuration = Configuration.create(environment);

      expect(configuration, isA<Configuration>());
    });

    test('creates a production configuration', () {
      final environment = MockEnvironment();

      when(environment.isAndroid).thenReturn(false);
      when(environment.isDevelopment).thenReturn(false);
      when(environment.isProduction).thenReturn(true);
      final configuration = Configuration.create(environment);

      expect(configuration, isA<ProductionConfiguration>());
    });
  });
}