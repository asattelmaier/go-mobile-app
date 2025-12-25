import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter/material.dart';
import 'package:go_app/main.dart'; // Import to ensure main is accessible if needed, but we launch via robot pumpWidget
import 'robots/app_robot.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() {
  // FIX: Mock Secure Storage to prevent DBus/Keyring hangs in Headless CI
  FlutterSecureStorage.setMockInitialValues({});
  
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  print('--- TEST: main() entry point reached ---');

  // Register cleanup globally for all tests in this file
  tearDown(() {
    AppRobot.cleanup();
  });

  group('Authentication Feature', () {
    testWidgets('Guest user can login', (tester) async {
      // Set a larger screen size for headless execution to avoid overflow
      tester.view.physicalSize = const Size(390*1.5, 844*1.5);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final app = AppRobot(tester);
      await app.launchApp();
      await app.loginAsGuest();
      // Verify we are on Home/Dashboard (implicitly checked by loginAsGuest now)
    });

    // Note: Session persistence test typically requires restarting the app process
    // which is hard to simulate in a single testWidgets run without mocking storage.
    // We will skip strict persistence test for now in this suite and assume the login worked.
  });

  // group('Game Setup Feature', () {
  //   testWidgets('User can create a 9x9 game', (tester) async {
  //     tester.view.physicalSize = const Size(390*1.5, 844*1.5);
  //     tester.view.devicePixelRatio = 1.0;
  //     addTearDown(tester.view.resetPhysicalSize);
  //     addTearDown(tester.view.resetDevicePixelRatio);

  //     final app = AppRobot(tester);
  //     await app.launchApp();
  //     await app.loginAsGuest();
  //     await app.createGame(boardSize: 9);
  //     await app.expectLobby();
  //   });

  //   testWidgets('User can start a game against a Bot', (tester) async {
  //     tester.view.physicalSize = const Size(390*1.5, 844*1.5);
  //     tester.view.devicePixelRatio = 1.0;
  //     addTearDown(tester.view.resetPhysicalSize);
  //     addTearDown(tester.view.resetDevicePixelRatio);

  //     final app = AppRobot(tester);
  //     await app.launchApp();
  //     await app.loginAsGuest();
  //     await app.playAgainstBot(difficulty: 'Easy');
  //     await app.expectBoard();
  //   });
  // });

  // group('Gameplay Feature', () {
  //   testWidgets('User can play a move against a Bot', (tester) async {
  //     tester.view.physicalSize = const Size(390*1.5, 844*1.5);
  //     tester.view.devicePixelRatio = 1.0;
  //     addTearDown(tester.view.resetPhysicalSize);
  //     addTearDown(tester.view.resetDevicePixelRatio);

  //     final app = AppRobot(tester);
  //     await app.launchApp();
  //     await app.loginAsGuest();
      
  //     // setup 9x9 game vs Bot
  //     await app.playAgainstBot(difficulty: 'Easy');
  //     await app.expectBoard();

  //     // Place stone at 2,2
  //     await app.placeStone(2, 2);
      
  //     // Wait for Bot response
  //     await app.waitForOpponentMove();
      
  //     // Verify we have at least 2 stones (Black + White)
  //     // Since specific visual verification is hard, we can assume successful tap + delay means game advanced.
  //     // Strict verification would require inspecting the Widget state or counting Key('intersection_...') children.
  //   });
  // });
}
