import 'package:flutter/material.dart' hide Router;
import 'package:go_app/game-session/client/game_session_client.dart';
import 'package:go_app/game/game_controller.dart';
import 'package:go_app/l10n/generated/app_localizations.dart';
import 'package:go_app/pages/home/home_page_view.dart';
import 'package:go_app/router/router.dart';
import 'package:go_app/theme/go_theme.dart';
import 'package:go_app/user/user_controller.dart';
import 'package:go_app/widgets/clay_button/clay_button.dart';

class GameFooter extends StatelessWidget {
  final GameController gameController;
  final GameSessionClient gameSessionClient;
  final UserController userController;

  const GameFooter({
    Key? key,
    required this.gameController,
    required this.gameSessionClient,
    required this.userController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = GoTheme.of(context);
    final l10n = AppLocalizations.of(context)!;

    if (gameController.isGameOver) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: ClayButton(
          text: l10n.back,
          color: theme.colorScheme.surface,
          textColor: theme.colorScheme.onSurface,
          width: 160,
          onTap: () {
            Router.push(context, HomePageView(gameSessionClient, userController));
          },
        ),
      );
    }

    // Maintain layout size to prevent jumps
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Visibility(
        visible: gameController.isPlayersTurn,
        maintainSize: true,
        maintainAnimation: true,
        maintainState: true,
        child: ClayButton(
          text: l10n.pass,
          color: theme.colorScheme.primary,
          textColor: theme.colorScheme.onPrimary,
          width: 160,
          onTap: () {
            gameController.pass();
          },
        ),
      ),
    );
  }
}
