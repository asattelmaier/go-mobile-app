import 'package:flutter_test/flutter_test.dart';
import 'package:go_app/game/settings/settings_model.dart';

void main() {
  group('empty', () {
    test('has no board size', () {
      final settings = SettingsModel.empty();

      expect(settings.boardSize, 0);
    });
  });
}
