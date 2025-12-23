import 'package:flutter/material.dart' hide Router;
import 'package:flutter/services.dart';
import 'package:go_app/game-session/client/game_session_client.dart';
import 'package:go_app/game-session/game_session_controller.dart';
import 'package:go_app/game-session/game_session_model.dart';
import 'package:go_app/game/bot/bot_difficulty.dart';
import 'package:go_app/game/settings/settings_model.dart';
import 'package:go_app/l10n/generated/app_localizations.dart';
import 'package:go_app/pages/game/game_page_view.dart';
import 'package:go_app/pages/home/home_page_view.dart';
import 'package:go_app/router/router.dart';
import 'package:go_app/theme/go_theme.dart';
import 'package:go_app/user/user_controller.dart';
import 'package:go_app/widgets/background/home_background.dart';
import 'package:go_app/widgets/clay_button/clay_button.dart';
import 'package:go_app/widgets/clay_card/clay_card.dart';
import 'package:go_app/widgets/clay_text/clay_headline.dart';
import 'package:go_app/widgets/clay_text/clay_sub_headline.dart';
import 'package:go_app/widgets/layout/page_layout_grid.dart';

class LobbyPageView extends StatefulWidget {
  final GameSessionClient _gameSessionClient;
  final UserController _userController;
  final SettingsModel _settings;
  final BotDifficulty? _botDifficulty;

  const LobbyPageView(
      this._gameSessionClient, this._userController, this._settings,
      [this._botDifficulty]);

  @override
  State<LobbyPageView> createState() => _LobbyPageViewState();
}

class _LobbyPageViewState extends State<LobbyPageView> {
  bool _hasNavigated = false;
  bool _sessionCreated = false;

  late final Stream<GameSessionModel> _createdStream;

  @override
  void initState() {
    super.initState();
    _createdStream = widget._gameSessionClient.created;
    _createSession();
  }

  void _createSession() {
    if (_sessionCreated) return;
    _sessionCreated = true;

    if (widget._userController.isUserLoggedIn) {
      widget._gameSessionClient.createSession(widget._userController.user,
          widget._botDifficulty, widget._settings.boardSize);
    } else {
      widget._userController.createGuestUser().then((user) => widget
          ._gameSessionClient
          .createSession(
              user, widget._botDifficulty, widget._settings.boardSize));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = GoTheme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return StreamBuilder<GameSessionModel>(
        initialData: GameSessionModel.empty(),
        stream: _createdStream,
        builder: (_, gameSessionModelSnapshot) {
          final gameSessionId = gameSessionModelSnapshot.data!.id;
          final gameSession = gameSessionModelSnapshot.data!;

          if (gameSession.isRunning && !_hasNavigated) {
            _hasNavigated = true;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Router.push(
                  context,
                  GamePageView(
                      GameSessionController(
                          widget._gameSessionClient,
                          gameSession,
                          gameSession.players.firstWhere(
                              (p) => p.id == widget._userController.user.id,
                              orElse: () => gameSession.players.first)),
                      widget._gameSessionClient,
                      widget._userController));
            });
          }


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
                        includeBottomSpacer: false, // Allow full height for scrolling
                        header: Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ClayHeadline(l10n.lobby),
                              SizedBox(height: 8),
                              Text(
                                "${widget._settings.boardSize}x${widget._settings.boardSize}",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontFamily: theme.fontFamily,
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.onSurface
                                      .withValues(alpha: 0.7),
                                ),
                              ),
                            ],
                          ),
                        ),
                        content: SingleChildScrollView(
                          child: SizedBox(
                            width: double.infinity,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                            ClaySubHeadline(l10n.invite),
                            SizedBox(height: 16),
                            Text(
                                l10n.shareGameId,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: theme.fontFamily,
                                  fontSize: 16,
                                  color: theme.colorScheme.onSurface,
                                ),
                              ),
                             SizedBox(height: 16),
                            // Invite Card
                            ClayCard(
                              width: 320,
                              height: 160,
                              color: theme.colorScheme.surface,
                              borderRadius: 24,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                    child: Text(
                                      gameSessionId.isEmpty
                                          ? "..."
                                          : gameSessionId,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: theme.fontFamily,
                                        fontSize: 28, // Slightly reduced from 32
                                        fontWeight: FontWeight.w900,
                                        color: theme.colorScheme.primary,
                                        letterSpacing: 2.0,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  ClayButton(
                                    text: l10n.share,
                                    color: theme.colorScheme.secondary,
                                    textColor: Colors.white,
                                    width: 140,
                                    height: 45,
                                    onTap: () {
                                      Clipboard.setData(
                                          ClipboardData(text: gameSessionId));
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text(l10n.copiedToClipboard),
                                      ));
                                    },
                                    // icon: Icons.share, // Add icon if available in ClayButton
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 40),

                            // Player Status List
                            _buildPlayerStatusRow(
                                l10n.you,
                                widget._userController.user.isPresent
                                    ? widget._userController.user.username
                                    : "Guest",
                                true,
                                l10n.ready,
                                theme),
                            SizedBox(height: 16),
                            _buildPlayerStatusRow(l10n.opponent,
                                l10n.waiting, false, l10n.waiting, theme),
                            SizedBox(height: 40),
                            ClayButton(
                              text: l10n.cancel,
                              color: theme.colorScheme.tertiary,
                              textColor: Colors.white,
                              width: 240,
                              height: 60,
                              onTap: () {
                                if (gameSessionId.isNotEmpty) {
                                  widget._gameSessionClient
                                      .terminateSession(gameSessionId);
                                }
                                Router.push(context,
                                    HomePageView(widget._gameSessionClient, widget._userController));
                              },
                            ),
                            SizedBox(height: 40),
                          ],
                        ),
                        ),
                        ),
                        footer: const SizedBox.shrink(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  Widget _buildPlayerStatusRow(String roleLabel, String name, bool isReady,
      String statusText, GoTheme theme) {
    return SizedBox(
      width: 300,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  roleLabel,
                  style: TextStyle(
                    fontFamily: theme.fontFamily,
                    fontSize: 14,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: theme.fontFamily,
                    fontSize: 20,
                    color: theme.colorScheme.onSurface,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isReady
                  ? Colors.green.withValues(alpha: 0.2)
                  : Colors.orange.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isReady ? Colors.green : Colors.orange,
                width: 2,
              ),
            ),
            child: Text(
              statusText,
              style: TextStyle(
                fontFamily: theme.fontFamily,
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isReady ? Colors.green[700] : Colors.orange[800],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

