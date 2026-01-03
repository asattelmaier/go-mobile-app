import 'dart:convert';
import 'dart:io';
import 'package:integration_test/integration_test_driver.dart';

Future<void> main() async {
  await integrationDriver(
    writeResponseOnFailure: true,
    responseDataCallback: (data) async {
      if (data == null) return;
      
      if (data.containsKey('testLog')) {
        stdout.writeln('\n=== INTEGRATION TEST LOGS (Reported) ===');
        final logs = (data['testLog'] as String).split('\n');
        for (final line in logs) {
          stdout.writeln(line);
        }
        stdout.writeln('=== /INTEGRATION TEST LOGS ===\n');
      } else {
        // Fallback for other data
        final pretty = const JsonEncoder.withIndent('  ').convert(data);
        stdout.writeln('=== integration_test responseData ===\n$pretty\n=== /responseData ===');
      }
    },
  );
}
