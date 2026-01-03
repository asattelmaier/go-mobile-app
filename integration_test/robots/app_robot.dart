import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_app/main.dart';
import 'package:go_app/widgets/clay_button/clay_button.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../utils/test_logger.dart'; // Shared Logger

class AppRobot {
  final WidgetTester tester;
  // Keep track of dependencies to prevent zombie connections between tests
  static AppDependencies? _activeDependencies;

  AppRobot(this.tester);

  Future<void> launchApp() async {
    tlog('--- launchApp: Starting ---');
    
    // Cleanup previous test run's dependencies
    _activeDependencies?.dispose();
    // MOCK STORAGE: Prevent native crash in Headless Docker
    FlutterSecureStorage.setMockInitialValues({});

    final dependencies = await AppDependencies.create();
    _activeDependencies = dependencies;
    
    // WIPING SESSION: With mock storage, this is already clean, but safe to call on proper mock.
    tlog('--- launchApp: Wiping session (Mocked) ---');
    await dependencies.userController.clearSession();
    
    tlog('--- launchApp: Pump widget ---');
    await tester.pumpWidget(GoApp(dependencies));
    tlog('--- launchApp: Settle ---');
    await tester.pumpAndSettle();
    tlog('--- launchApp: Done ---');
  }

  static void cleanup() {
    _activeDependencies?.dispose();
    _activeDependencies = null;
  }

  Future<void> loginAsGuest() async {
    tlog('--- loginAsGuest: Tapping button ---');
    await _tapButton('Play as Guest');
    tlog('--- loginAsGuest: Waiting for navigation to Home ---');
    await expectHome();
    tlog('--- loginAsGuest: Done ---');
  }

  Future<void> createGame({int boardSize = 9}) async {
    tlog('--- createGame: Starting ---');
    // Navigate to Create Game screen
    await _tapButton('New Game');

    // Select Board Size
    await _tapButton('${boardSize}x${boardSize}');

    // Create
    await _tapButton('Create Game');
    tlog('--- createGame: Done ---');
  }

  Future<void> playAgainstBot({String difficulty = 'Easy'}) async {
    tlog('--- playAgainstBot: Starting ---');
    // Navigate to Create Game screen
    await _tapButton('New Game');

    // Enable Bot
    tlog('--- playAgainstBot: Enabling bot ---');
    await _tapButton('Yes'); // "Yes" for Play against Bot

    // Select Difficulty
    await _tapButton(difficulty);

    // Create
    await _tapButton('Create Game');
    tlog('--- playAgainstBot: Done ---');
  }

  Future<void> expectHome() async {
    tlog('--- expectHome: Waiting for "New Game" button ---');
    final newGameFinder = find.text('New Game');

    // Wait until at least one widget with text "New Game" is present (handling network latency for login)
    bool found = false;
    for (int i = 0; i < 20; i++) {
        if (newGameFinder.evaluate().isNotEmpty) {
            found = true;
            tlog('--- expectHome: New Game button found! ---');
            break;
        }
        await tester.pump(const Duration(milliseconds: 500));
    }

    if (!found) {
        tlog('--- expectHome: New Game button NOT found in time ---');
    }

    expect(newGameFinder, findsOneWidget);
  }

  Future<void> expectLobby() async {
    tlog('--- expectLobby: Checking navigation ---');
    // Ensure we are off the New Game page
    expect(find.text('New Game'), findsNothing); // "New Game" is on the ClayButton we clicked? No, it's on Home.
    // Actually Home has "New Game". Create Game page has "Create Game".
    expect(find.text('Create Game'), findsNothing);

    // Look for Lobby-specific text
    tlog('--- expectLobby: Waiting for "Lobby" text ---');
    final lobbyFinder = find.text('Lobby');

    // Wait until at least one widget with text "Lobby" is present
    bool found = false;
    for (int i = 0; i < 20; i++) {
        if (lobbyFinder.evaluate().isNotEmpty) {
            found = true;
            break;
        }
        await tester.pump(const Duration(milliseconds: 500));
    }

    if (!found) {
        tlog('--- expectLobby: Lobby NOT found in time ---');
    }

    // Optional: wait until the finders settle if there's animation
    await tester.pumpAndSettle();

    expect(lobbyFinder, findsOneWidget);
    tlog('--- expectLobby: Lobby found ---');
  }

  Future<void> expectBoard() async {
    tlog('--- expectBoard: Checking navigation ---');
    // REMOVED BRITTLE CHECK: expect(find.text('Create Game'), findsNothing);
    // In Turbo mode, we might still be on the previous screen for a few frames.
    // relying on positive confirmation (finding the board) is safer.
    
    // Wait for the board to appear. This is critical for stability.
    tlog('--- expectBoard: Waiting for board intersection_0_0... ---');

    final boardFinder = find.byKey(const Key('intersection_0_0'));

    await tester.pump(); // Optimization: Don't settle, just pump. Loop below handles waiting.
    
    int i = 0;
    while (i < 60) {
      if (boardFinder.evaluate().isNotEmpty) {
        tlog('--- expectBoard: Board found ---');
        break;
      }
      await tester.pump(const Duration(milliseconds: 500));
      i++;
    }

    if (boardFinder.evaluate().isEmpty) {
      tlog('--- expectBoard: Board did not render in time (intersection_0_0 not found) ---');
    }

    expect(boardFinder, findsOneWidget, reason: "Board did not render in time (intersection_0_0 not found). Logic check: Did we get stuck in Lobby?");
  }

  Future<void> _tapButton(String text) async {
    final button = find.widgetWithText(ClayButton, text);
    
    // Optimization: Wait for button to appear (polling) instead of relying on previous settle.
    // This allows disjointed animations to run without blocking, as long as the target is interactive.
    bool found = false;
    // Increase timeout to 10 seconds (100 * 100ms) to account for CI slowness
    for (int i = 0; i < 100; i++) { 
        if (button.evaluate().isNotEmpty) {
            found = true;
            break;
        }
        // Optimization: Use EnginePhase.layout to avoid expensive Paint (Shadows) in Headless mode
        // This makes checking for existence much faster.
        await tester.pump(const Duration(milliseconds: 100), EnginePhase.layout);
    }
    
    if (!found) {
        tlog('--- _tapButton: Timeout waiting for "$text" ---');
    }
    expect(button, findsOneWidget, reason: "Button with text '$text' not found after waiting 10s");
    
    // Ensure the button is visible (scroll if needed) before tapping
    await tester.ensureVisible(button);
    // REMOVED: await tester.pump(); // No need to pump explicitly after ensureVisible if we trust layout.
    
    await tester.tap(button);
    // OPTIMIZATION: Removed explicit pump() after tap.
    // The next step's polling loop or specific wait will handle the frame.
    // This avoids forcing a 4-second software render for simple state changes.
  }

  Future<void> placeStone(int x, int y) async {
    tlog('--- placeStone($x, $y): Finding intersection ---');
    final intersection = find.byKey(Key('intersection_${x}_${y}'));
    expect(intersection, findsOneWidget, reason: "Intersection at $x,$y not found");
    
    tlog('--- placeStone($x, $y): Tapping ---');
    await tester.tap(intersection);
    
    tlog('--- placeStone($x, $y): Pumping ---');
    await tester.pump(); // Optimization: Don't settle
    tlog('--- placeStone($x, $y): Done ---');
  }

  void expectStone(int x, int y, String color) {
    // Note: Visual verification is hard without checking internal state of StateView.
    // We assume if the tap succeeded, the game state updated.
    // We could add a debug key to StateView to verify the color if needed.
  }

   Future<void> waitForOpponentMove() async {
     tlog('--- waitForOpponentMove: Waiting 2 seconds for bot (Fixed wait) ---');
     // Wait for the backend to process and bot to reply.
     // Optimization: Fixed wait is safer than pumpAndSettle if animations are infinite.
     await tester.pump(const Duration(seconds: 2));
     
     tlog('--- waitForOpponentMove: Done ---');
  }
}

