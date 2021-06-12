import 'package:flutter/material.dart' hide Router;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_app/game-session/game_session_controller.dart';
import 'package:go_app/layout/default/default_layout.dart';
import 'package:go_app/pages/game/game_page_view.dart';
import 'package:go_app/pages/home/home_page_view.dart';
import 'package:go_app/router/router.dart';
import 'package:go_app/theme/go_theme.dart';
import 'package:go_app/widgets/bottom_action_bar/buttons/back_button/back_button.dart';
import 'package:go_app/widgets/bottom_action_bar/buttons/join_button/join_button_view.dart';

class JoinGamePageView extends StatelessWidget {
  final GameSessionController _gameSessionController;
  final _textEditingController = TextEditingController();

  JoinGamePageView(this._gameSessionController);

  @override
  Widget build(BuildContext context) {
    _gameSessionController.onJoined((_) {
      Router.push(context, GamePageView(_gameSessionController));
    });

    return DefaultLayout(
      body: Padding(
          padding: EdgeInsets.all(GoTheme.of(context).gutter * 6),
          child: TextField(
            controller: _textEditingController,
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: AppLocalizations.of(context)!.enterGameSessionId),
          )),
      bottomActionBar: [
        BackButtonView(HomePageView(_gameSessionController)),
        JoinButtonView(_gameSessionController, _textEditingController),
      ],
    );
  }
}
