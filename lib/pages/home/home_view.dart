import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_app/game-session/game_session_controller.dart';
import 'package:go_app/game/game_controller.dart';
import 'package:go_app/game/game_view.dart';
import 'package:go_app/theme/go_theme.dart';
import 'package:go_app/widgets/bottom_action_bar/bottom_action_bar_controller.dart';
import 'package:go_app/widgets/bottom_action_bar/bottom_action_bar_view.dart';

class HomeView extends StatelessWidget {
  final GameSessionController _gameSessionController;
  final GameController _gameController;

  HomeView(this._gameSessionController, this._gameController);

  @override
  Widget build(BuildContext context) {
    final theme = GoTheme.of(context);

    return SafeArea(
        child: Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: Stack(children: [
        GameView(_gameController),
        if (_gameSessionController.isPending)
          _createIsPendingInformation(context)
      ]),
      bottomNavigationBar: BottomActionBarView(_bottomActionBarController),
    ));
  }

  BottomActionBarController get _bottomActionBarController {
    return BottomActionBarController(_gameSessionController, _gameController);
  }

  Widget _createIsPendingInformation(BuildContext context) {
    final borderWidth = GoTheme.of(context).borderWidth;
    final gutter = GoTheme.of(context).gutter;
    final waitingForPlayer = AppLocalizations.of(context)!.waitingForPlayer;

    return Align(
        alignment: Alignment.center,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(waitingForPlayer, textAlign: TextAlign.center),
          Padding(
              padding: EdgeInsets.all(gutter * 6),
              child: CircularProgressIndicator(strokeWidth: borderWidth))
        ]));
  }
}
