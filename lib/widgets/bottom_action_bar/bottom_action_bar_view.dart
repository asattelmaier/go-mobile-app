import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_app/pages/join_game/join_game_view.dart';
import 'package:go_app/theme/go_theme.dart';
import 'package:go_app/widgets/bottom_action_bar/bottom_action_bar_controller.dart';

class BottomActionBarView extends StatelessWidget {
  final BottomActionBarController _controller;

  const BottomActionBarView(this._controller);

  @override
  Widget build(BuildContext context) {
    final gutter = GoTheme.of(context).gutter;

    return BottomAppBar(
        child: Padding(
      padding: EdgeInsets.only(
          top: gutter, bottom: gutter, left: gutter * 2, right: gutter * 2),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          _createNewGameButton(context),
          Visibility(
            visible: _controller.isJoinGameButtonVisible,
            child: _createJoinGameButton(context),
          ),
          Visibility(
            visible: _controller.isPassButtonVisible,
            child: _createPassButton(context),
          )
        ],
      ),
    ));
  }

  Widget _createNewGameButton(BuildContext context) {
    return TextButton.icon(
      label: Text(AppLocalizations.of(context)!.newGame),
      icon: Icon(Icons.add),
      onPressed: () {
        _controller.createGameSession();
      },
    );
  }

  Widget _createJoinGameButton(BuildContext context) {
    return TextButton.icon(
      label: Text(AppLocalizations.of(context)!.joinGame),
      icon: Icon(Icons.add),
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    JoinGameView(_controller.gameSessionController)));
      },
    );
  }

  Widget _createPassButton(BuildContext context) {
    return TextButton.icon(
      label: Text(AppLocalizations.of(context)!.pass),
      icon: Icon(Icons.block),
      onPressed: () {
        _controller.pass();
      },
    );
  }
}
