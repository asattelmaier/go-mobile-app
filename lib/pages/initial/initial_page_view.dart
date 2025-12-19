import 'package:flutter/material.dart' hide Router;
import 'package:go_app/l10n/generated/app_localizations.dart';
import 'package:go_app/game-session/client/game_session_client.dart';
import 'package:go_app/pages/home/home_page_view.dart';
import 'package:go_app/router/router.dart';
import 'package:go_app/theme/go_theme.dart';
import 'package:go_app/user/user_controller.dart';
import 'package:go_app/pages/home/widgets/clay_button.dart';
import 'package:go_app/pages/home/widgets/home_background.dart';
import 'package:go_app/pages/home/widgets/clay_text.dart';
import 'package:go_app/pages/home/widgets/clay_forest.dart';

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
            child: ClayForest(),
          ),

          Positioned.fill(
            child: SafeArea(
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                     Spacer(flex: 1),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ClayText(
                          text: "G",
                          baseColor: theme.colorScheme.primary,
                          style: TextStyle(
                            fontSize: size.height * 0.22,
                            fontFamily: theme.fontFamily,
                            fontWeight: FontWeight.w900,
                            height: 1.0,
                          ),
                        ),
                        ClayText(
                          text: "O",
                          baseColor: theme.colorScheme.secondary,
                          style: TextStyle(
                            fontSize: size.height * 0.22,
                            fontFamily: theme.fontFamily,
                            fontWeight: FontWeight.w900,
                            height: 1.0,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 20),

                    Spacer(flex: 6),

                    SizedBox(height: 20),

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

                    Spacer(flex: 1),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
