import 'package:flutter/cupertino.dart';
import 'package:go_app/game/end_game/winner/winner_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class WinnerView extends StatelessWidget {
  final WinnerController _controller;

  WinnerView(this._controller);

  @override
  Widget build(BuildContext context) {
    if (_controller.isDrawn) {
      return _winner(context, AppLocalizations.of(context)!.drawn);
    }

    if (_controller.hasWhiteWon) {
      return _winner(context, AppLocalizations.of(context)!.white);
    }

    return _winner(context, AppLocalizations.of(context)!.black);
  }

Widget _winner(BuildContext context, String winner) {
    return Text(AppLocalizations.of(context)!.winner(winner));
  }
}
