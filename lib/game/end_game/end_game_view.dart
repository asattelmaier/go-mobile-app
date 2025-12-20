import 'package:flutter/material.dart';
import 'package:go_app/game/end_game/end_game_controller.dart';
import 'package:go_app/game/end_game/winner/winner_controller.dart';
import 'package:go_app/game/end_game/winner/winner_view.dart';
import 'package:go_app/l10n/generated/app_localizations.dart';
import 'package:go_app/theme/go_theme.dart';
import 'package:go_app/widgets/clay_card/clay_card.dart';
import 'package:go_app/widgets/clay_text/clay_headline.dart';

// TODO(ui): Refactor EndGameView to align with Claymorphism design system.
class EndGameView extends StatelessWidget {
  final EndGameController _controller;

  const EndGameView(this._controller);

  @override
  Widget build(BuildContext context) {
    final theme = GoTheme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Center(
      child: ClayCard(
        width: 300,
        color: theme.colorScheme.surface,
        borderRadius: 20,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClayHeadline("Game Over"),
              SizedBox(height: 20),
              WinnerView(WinnerController(_controller.winner)),
              SizedBox(height: 20),
              Text(
                l10n.score(_controller.score),
                style: TextStyle(
                  fontFamily: theme.fontFamily, // Use theme font
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
