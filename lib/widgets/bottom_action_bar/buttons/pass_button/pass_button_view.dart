import 'package:flutter/material.dart';
import 'package:go_app/game/game_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PassButtonView extends StatelessWidget {
  final GameController _gameController;

  const PassButtonView(this._gameController);

  @override
  Widget build(BuildContext context) => TextButton.icon(
    label: Text(AppLocalizations.of(context)!.pass),
    icon: Icon(Icons.block),
    onPressed: () {
      _gameController.pass();
    },
  );
}
