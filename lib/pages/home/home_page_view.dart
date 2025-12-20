import 'package:flutter/material.dart' hide Router;
import 'package:go_app/game-session/client/game_session_client.dart';
import 'package:go_app/l10n/generated/app_localizations.dart';
import 'package:go_app/widgets/background/home_background.dart';
import 'package:go_app/widgets/clay_button/clay_button.dart';
import 'package:go_app/pages/home/widgets/clay_forest_header.dart';
import 'package:go_app/widgets/clay_text/clay_text.dart';
import 'package:go_app/widgets/layout/page_layout_grid.dart';
import 'package:go_app/pages/join_game/join_game_page_view.dart';
import 'package:go_app/pages/new_game/create_game/create_game_page_view.dart';
import 'package:go_app/router/router.dart';
import 'package:go_app/theme/go_theme.dart';
import 'package:go_app/user/user_controller.dart';
import 'package:go_app/pages/initial/initial_page_view.dart';

import 'package:go_app/utils/rect_tweens.dart';

class HomePageView extends StatelessWidget {
  final GameSessionClient _gameSessionClient;
  final UserController _userController;

  HomePageView(this._gameSessionClient, this._userController);

  @override
  Widget build(BuildContext context) {
    final theme = GoTheme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          HomeBackground(),
          Align(
            alignment: Alignment.topCenter,
            child: Hero(
              tag: 'hero_forest',
              createRectTween: (b, e) => BouncyRectTween(begin: b, end: e),
              child: ClayForestHeader(),
            ),
          ),
          Positioned.fill(
            child: SafeArea(
              child: SizedBox(
                width: double.infinity,
                child: PageLayoutGrid(
                  topFlex: 5,
                  middleFlex: 2,
                  header: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Hero(
                        tag: 'hero_logo_g',
                        createRectTween: (b, e) =>
                            BouncyRectTween(begin: b, end: e),
                        child: ClayText(
                          text: "G",
                          baseColor: theme.colorScheme.primary,
                          style: TextStyle(
                            fontSize: size.height * 0.22,
                            fontFamily: theme.fontFamily,
                            fontWeight: FontWeight.w900,
                            height: 1.0,
                          ),
                        ),
                      ),
                      Hero(
                        tag: 'hero_logo_o',
                        createRectTween: (b, e) =>
                            BouncyRectTween(begin: b, end: e),
                        child: ClayText(
                          text: "O",
                          baseColor: theme.colorScheme.secondary,
                          style: TextStyle(
                            fontSize: size.height * 0.22,
                            fontFamily: theme.fontFamily,
                            fontWeight: FontWeight.w900,
                            height: 1.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                  footer: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ClayButton(
                        text: l10n.newGame,
                        color: theme.colorScheme.primary,
                        textColor: Colors.white,
                        width: 240,
                        height: 60,
                        onTap: () {
                          Router.push(
                            context,
                            CreateGamePageView(
                                _gameSessionClient, _userController),
                          );
                        },
                      ),
                      SizedBox(height: 20),
                      ClayButton(
                        text: l10n.joinGame,
                        color: theme.colorScheme.secondary,
                        textColor: Colors.white,
                        width: 240,
                        height: 60,
                        onTap: () {
                          Router.push(
                            context,
                            JoinGamePageView(_gameSessionClient, _userController),
                          );
                        },
                      ),
                      SizedBox(height: 20),
                      ClayButton(
                        text: l10n.logOut,
                        color: theme.colorScheme.tertiary,
                        textColor: Colors.white,
                        width: 240,
                        height: 60,
                        onTap: () {
                          // Logic to be implemented later, for now just navigate back
                           Router.push(
                            context,
                            InitialPageView(_gameSessionClient, _userController),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
