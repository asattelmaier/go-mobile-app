import 'package:flutter/material.dart' hide Router;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_app/game-session/client/game_session_client.dart';
import 'package:go_app/game-session/game_session_controller.dart';
import 'package:go_app/game-session/game_session_model.dart';
import 'package:go_app/layout/default/default_layout.dart';
import 'package:go_app/pages/game/game_page_view.dart';
import 'package:go_app/pages/home/home_page_view.dart';
import 'package:go_app/router/router.dart';
import 'package:go_app/theme/go_theme.dart';
import 'package:go_app/widgets/bottom_action_bar/buttons/back_button/back_button.dart';
import 'package:go_app/widgets/bottom_action_bar/buttons/join_button/join_button_view.dart';

class JoinGamePageView extends StatefulWidget {
  final GameSessionClient _gameSessionClient;

  const JoinGamePageView(this._gameSessionClient);

  @override
  State<JoinGamePageView> createState() =>
      _JoinGamePageView(_gameSessionClient);
}

class _JoinGamePageView extends State<JoinGamePageView> {
  final GameSessionClient _gameSessionClient;
  final _textEditingController = TextEditingController();
  List<GameSessionModel> _gameSessions = [];

  _JoinGamePageView(this._gameSessionClient);

  @override
  void initState() {
    super.initState();

    _gameSessionClient.getPendingSessions().then((gameSessions) => setState(() {
          _gameSessions = gameSessions;
        }));
  }

  @override
  Widget build(BuildContext context) {
    _gameSessionClient.joined.listen((GameSessionModel gameSession) {
      Router.push(
          context,
          GamePageView(GameSessionController(
              _gameSessionClient, gameSession, gameSession.players.last)));
    });

    return DefaultLayout(
      body: Padding(
          padding: EdgeInsets.all(GoTheme.of(context).gutter * 6),
          child: Row(children: [
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  Padding(
                      padding: EdgeInsets.only(
                          bottom: GoTheme.of(context).gutter * 6),
                      child: _sessionIdInputField(context)),
                  Expanded(child: _gameSessionsListView)
                ],
              ),
            )
          ])),
      bottomActionBar: [
        BackButtonView(HomePageView(_gameSessionClient)),
        JoinButtonView(_gameSessionClient, _textEditingController),
      ],
    );
  }

  Widget _sessionIdInputField(BuildContext context) {
    return TextField(
      controller: _textEditingController,
      decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: AppLocalizations.of(context)!.enterGameSessionId),
    );
  }

  Widget get _gameSessionsListView {
    return ListView.separated(
      itemCount: _gameSessions.length,
      separatorBuilder: (BuildContext context, int index) => Divider(
        thickness: 1.0,
      ),
      itemBuilder: (BuildContext context, int index) => ListTile(
        title: Text(_gameSessions[index].id),
        onTap: () => _gameSessionClient.joinSession(_gameSessions[index].id),
      ),
    );
  }
}
