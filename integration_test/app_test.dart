import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:go_app/main.dart';
import 'robots/app_robot.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'utils/test_logger.dart';

void main() async {
  // FIX: Mock Secure Storage to prevent DBus/Keyring hangs in Headless CI
  FlutterSecureStorage.setMockInitialValues({});
  
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  
  tearDownAll(() {
    // Report logs back to the Host Driver (Release Mode support)
    binding.reportData = {
      'testLog': testLogs.join('\n'),
    };
  });

  tlog('--- TEST: main() entry point reached ---');

  // Register cleanup globally for all tests in this file
  tearDown(() {
    AppRobot.cleanup();
  });

  group('Full User Journey', () {
    testWidgets('Guest Login -> Create Game (Back) -> Play Bot', (tester) async {
       tlog('--- TEST STARTED: Full User Journey (kIsWeb: $kIsWeb) ---');
      tester.view.physicalSize = const Size(390*1.5, 844*1.5);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final app = AppRobot(tester);
      await app.launchApp();
      await app.loginAsGuest();

      // J1: Play Against Bot Flow (Covers Game Creation + Gameplay)
      tlog('--- J1: Play Against Bot Flow ---');
      await app.playAgainstBot(difficulty: 'Easy');
      await app.expectBoard();

      // Place stone at 2,2
      await app.placeStone(2, 2);
      
      // Wait for Bot response
      await app.waitForOpponentMove();
      
      tlog('--- TEST FINISHED: Full User Journey ---');
    });
  });
}
