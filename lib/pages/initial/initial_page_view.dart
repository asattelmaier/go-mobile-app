import 'package:flutter/material.dart' hide Router;
import 'package:go_app/l10n/generated/app_localizations.dart';
import 'package:go_app/game-session/client/game_session_client.dart';
import 'package:go_app/pages/home/home_page_view.dart';
import 'package:go_app/router/router.dart';
import 'package:go_app/theme/go_theme.dart';
import 'package:go_app/user/user_controller.dart';
import 'package:go_app/widgets/background/home_background.dart';
import 'package:go_app/widgets/clay_button/clay_button.dart';
import 'package:go_app/pages/initial/widgets/clay_forest.dart';
import 'package:go_app/widgets/layout/page_layout_grid.dart';
import 'package:go_app/widgets/logo/clay_go_logo.dart';

import 'package:go_app/utils/rect_tweens.dart';

class InitialPageView extends StatelessWidget {
  final GameSessionClient _gameSessionClient;
  final UserController _userController;

  InitialPageView(this._gameSessionClient, this._userController);

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
            alignment: Alignment(0.0, -0.3),
            child: Hero(
              tag: 'hero_forest',
              createRectTween: (b, e) => BouncyRectTween(begin: b, end: e),
              child: ClayForest(),
            ),
          ),

          Positioned.fill(
            child: SafeArea(
              child: SizedBox(
                width: double.infinity,
                child: PageLayoutGrid(
                  topFlex: 1,
                  middleFlex: 6,
                  header: const ClayGoLogo(),
                  footer: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ClayButton(
                        text: l10n.playAsGuest,
                        color: theme.colorScheme.secondary,
                        textColor: Colors.white,
                        width: 240,
                        height: 60,
                        onTap: () async {
                          await _userController.createGuestUser();
                          await _gameSessionClient.connect();
                          Router.push(context, HomePageView(_gameSessionClient, _userController));
                        },
                      ),
                      SizedBox(height: 20),
                      ClayButton(
                        text: l10n.logIn,
                        color: theme.colorScheme.primary,
                        textColor: Colors.white,
                        width: 240,
                        height: 60,
                        onTap: () {
                        },
                      ),
                      SizedBox(height: 20),
                      ClayButton(
                        text: l10n.register,
                        color: theme.colorScheme.tertiary,
                        textColor: Colors.white,
                        width: 240,
                        height: 60,
                        onTap: () {
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
