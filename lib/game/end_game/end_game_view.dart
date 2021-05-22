import 'package:flutter/cupertino.dart';
import 'package:go_app/game/end_game/end_game_controller.dart';
import 'package:go_app/game/end_game/winner/winner_controller.dart';
import 'package:go_app/game/end_game/winner/winner_view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EndGameView extends StatelessWidget {
  final EndGameController _controller;

  const EndGameView(this._controller);

  @override
  Widget build(BuildContext context) => Center(
        child: Column(
          children: [
            WinnerView(WinnerController(_controller.winner)),
            Text(AppLocalizations.of(context)!.score(_controller.score))
          ],
        ),
      );
}
