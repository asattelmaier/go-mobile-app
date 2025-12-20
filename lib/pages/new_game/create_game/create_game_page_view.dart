import 'package:flutter/material.dart' hide Router;
import 'package:go_app/game-session/client/game_session_client.dart';
import 'package:go_app/game/settings/settings_model.dart';
import 'package:go_app/l10n/generated/app_localizations.dart';
import 'package:go_app/pages/home/home_page_view.dart';
import 'package:go_app/pages/new_game/game_pending/game_pending_page_view.dart';
import 'package:go_app/router/router.dart';
import 'package:go_app/theme/go_theme.dart';
import 'package:go_app/user/user_controller.dart';
import 'package:go_app/widgets/background/home_background.dart';
import 'package:go_app/widgets/clay_button/clay_button.dart';
import 'package:go_app/widgets/clay_text/clay_text.dart';
import 'package:go_app/widgets/layout/page_layout_grid.dart';

class CreateGamePageView extends StatefulWidget {
  final GameSessionClient _gameSessionClient;
  final UserController _userController;

  const CreateGamePageView(this._gameSessionClient, this._userController);

  @override
  State<CreateGamePageView> createState() =>
      _CreateGamePageView(_gameSessionClient, _userController);
}

class _CreateGamePageView extends State<CreateGamePageView> {
  final UserController _userController;
  final GameSessionClient _gameSessionClient;
  
  int _boardSize = 9;
  bool _isSuicideAllowed = false;

  _CreateGamePageView(this._gameSessionClient, this._userController);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = GoTheme.of(context);

    return Scaffold(
      body: Stack(
        children: [
          HomeBackground(),
          Positioned.fill(
            child: SafeArea(
              child: SizedBox(
                width: double.infinity,
                child: PageLayoutGrid(
                  topFlex: 0,
                  middleFlex: 1,
                  header: Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Text(
                      l10n.options,
                      style: TextStyle(
                        fontSize: 48,
                        fontFamily: theme.fontFamily,
                        fontWeight: FontWeight.w900,
                        color: theme.colorScheme.onSurface,
                        shadows: [
                          Shadow(
                            color: Colors.white.withValues(alpha: 0.5),
                            offset: Offset(2, 2),
                            blurRadius: 0,
                          ),
                        ],
                      ),
                    ),
                  ),
                  content: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Board Size Section
                      Text(
                        l10n.boardSize,
                        style: TextStyle(
                          fontFamily: theme.fontFamily,
                          fontSize: 24,
                          color: theme.colorScheme.onSurface,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildBoardSizeButton(9, theme),
                          SizedBox(width: 12),
                          _buildBoardSizeButton(13, theme),
                          SizedBox(width: 12),
                          _buildBoardSizeButton(19, theme),
                        ],
                      ),
                      SizedBox(height: 32),
                      
                      // Suicide Rule Section
                      Text(
                        l10n.isSuicideAllowed,
                        style: TextStyle(
                          fontFamily: theme.fontFamily,
                          fontSize: 24,
                          color: theme.colorScheme.onSurface,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildSuicideButton(true, l10n.yes, theme),
                          SizedBox(width: 12),
                          _buildSuicideButton(false, l10n.no, theme),
                        ],
                      ),
                    ],
                  ),
                  footer: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ClayButton(
                        text: l10n.createGame,
                        color: theme.colorScheme.primary,
                        textColor: Colors.white,
                        width: 240,
                        height: 60,
                        onTap: _onCreateGame,
                      ),
                      SizedBox(height: 20),
                      ClayButton(
                        text: l10n.back,
                        color: theme.colorScheme.tertiary,
                        textColor: Colors.white,
                        width: 240,
                        height: 60,
                        onTap: () {
                          Router.push(
                            context,
                            HomePageView(_gameSessionClient, _userController),
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

  Widget _buildBoardSizeButton(int size, GoTheme theme) {
    final isSelected = _boardSize == size;
    return ClayButton(
      text: "${size}x$size",
      color: isSelected ? theme.colorScheme.primary : theme.colorScheme.surface,
      textColor: isSelected ? Colors.white : theme.colorScheme.onSurface,
      width: 80,
      height: 50,
      onTap: () {
        setState(() {
          _boardSize = size;
        });
      },
      // Using a slightly different style for unselected if needed, 
      // but standard ClayButton handles color well.
    );
  }

  Widget _buildSuicideButton(bool value, String label, GoTheme theme) {
    final isSelected = _isSuicideAllowed == value;
    return ClayButton(
      text: label,
      color: isSelected ? theme.colorScheme.primary : theme.colorScheme.surface,
      textColor: isSelected ? Colors.white : theme.colorScheme.onSurface,
      width: 100,
      height: 50,
      onTap: () {
        setState(() {
          _isSuicideAllowed = value;
        });
      },
    );
  }

  void _onCreateGame() {
      Router.push(
          context,
          GamePendingPageView(
              _gameSessionClient, 
              _userController, 
              SettingsModel(_boardSize, _isSuicideAllowed)
          )
      );
  }
}
