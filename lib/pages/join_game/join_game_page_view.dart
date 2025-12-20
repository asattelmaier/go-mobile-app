import 'dart:async';
import 'package:flutter/material.dart' hide Router;
import 'package:go_app/game-session/client/game_session_client.dart';
import 'package:go_app/game-session/game_session_controller.dart';
import 'package:go_app/game-session/game_session_model.dart';
import 'package:go_app/l10n/generated/app_localizations.dart';
import 'package:go_app/pages/game/game_page_view.dart';
import 'package:go_app/pages/home/home_page_view.dart';
import 'package:go_app/pages/join_game/widgets/active_game_list.dart';
import 'package:go_app/pages/join_game/widgets/game_code_input.dart';
import 'package:go_app/pages/join_game/widgets/join_game_footer.dart';
import 'package:go_app/router/router.dart';
import 'package:go_app/user/user_controller.dart';
import 'package:go_app/widgets/background/home_background.dart';
import 'package:go_app/widgets/clay_text/clay_headline.dart';
import 'package:go_app/widgets/layout/page_layout_grid.dart';

class JoinGamePageView extends StatefulWidget {
  final GameSessionClient _gameSessionClient;
  final UserController _userController;

  const JoinGamePageView(this._gameSessionClient, this._userController);

  @override
  State<JoinGamePageView> createState() =>
      _JoinGamePageView(_gameSessionClient, _userController);
}

class _JoinGamePageView extends State<JoinGamePageView> {
  final GameSessionClient _gameSessionClient;
  final UserController _userController;
  final _textEditingController = TextEditingController();
  List<GameSessionModel> _gameSessions = [];
  Timer? _pollTimer;
  StreamSubscription? _joinedSubscription;
  static const int _pollIntervalSeconds = 5;

  _JoinGamePageView(this._gameSessionClient, this._userController);

  @override
  void initState() {
    super.initState();
    _fetchGameSessions();
    _startPolling();
    _subscribeToJoinedGame();
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    _joinedSubscription?.cancel();
    _textEditingController.dispose();
    super.dispose();
  }

  void _startPolling() {
    _pollTimer = Timer.periodic(const Duration(seconds: _pollIntervalSeconds), (timer) {
      _fetchGameSessions();
    });
  }

  void _subscribeToJoinedGame() {
    _joinedSubscription =
        _gameSessionClient.joined.listen((GameSessionModel gameSession) {
      if (gameSession.players.isNotEmpty) {
        Router.push(
            context,
            GamePageView(
                GameSessionController(
                    _gameSessionClient, gameSession, gameSession.players.last),
                _userController));
      }
    });
  }

  void _fetchGameSessions() {
    _gameSessionClient.getPendingSessions().then((gameSessions) {
      if (mounted) {
        setState(() {
          _gameSessions = gameSessions;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

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
                    child: ClayHeadline(l10n.joinGame),
                  ),
                  content: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: GameCodeInput(controller: _textEditingController),
                      ),
                      SizedBox(height: 20),
                      ActiveGameList(
                        gameSessions: _gameSessions,
                        gameSessionClient: _gameSessionClient,
                      ),
                    ],
                  ),
                  footer: JoinGameFooter(
                    onTapBack: () {
                      Router.push(context,
                          HomePageView(_gameSessionClient, _userController));
                    },
                    onTapJoin: () {
                      if (_textEditingController.text.isNotEmpty) {
                        _gameSessionClient
                            .joinSession(_textEditingController.text);
                      }
                    },
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
