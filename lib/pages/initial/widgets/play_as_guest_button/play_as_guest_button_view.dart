import 'package:flutter/material.dart' hide Router;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_app/game-session/client/game_session_client.dart';
import 'package:go_app/pages/home/home_page_view.dart';
import 'package:go_app/router/router.dart';
import 'package:go_app/theme/go_theme.dart';
import 'package:go_app/user/user_controller.dart';
import 'package:go_app/widgets/button/button_view.dart';

class PlayAsGuestButtonView extends StatelessWidget {
  final GameSessionClient _gameSessionClient;
  final UserController _userController;

  const PlayAsGuestButtonView(this._gameSessionClient, this._userController);

  @override
  Widget build(BuildContext context) {
    final theme = GoTheme.of(context);

    return ButtonView(
      text: Text(
        AppLocalizations.of(context)!.playAsGuest,
        style: TextStyle(
          color: Colors.white,
          fontSize: 30,
          fontFamily: theme.fontFamily,
          fontWeight: FontWeight.w600,
          decoration: TextDecoration.none,
        ),
      ),
      backgroundGradient: LinearGradient(
        colors: [
          Color.fromRGBO(253, 211, 98, 1),
          Color.fromRGBO(255, 192, 60, 1),
          Color.fromRGBO(250, 169, 27, 1),
          Color.fromRGBO(227, 121, 0, 1),
        ],
        stops: [0, 0.1, 0.6, 1],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      onTab: () async {
        await _userController.createGuestUser();
        await _gameSessionClient.connect();

        Router.push(context, HomePageView(_gameSessionClient, _userController));
      },
    );
  }
}
