import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_app/game-session/client/game_session_client.dart';
import 'package:go_app/game/settings/settings_model.dart';
import 'package:go_app/layout/default/default_layout.dart';
import 'package:go_app/pages/home/home_page_view.dart';
import 'package:go_app/user/user_controller.dart';
import 'package:go_app/widgets/bottom_action_bar/buttons/back_button/back_button.dart';
import 'package:go_app/widgets/bottom_action_bar/buttons/create_game_button/create_game_button_view.dart';

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
  final _formKey = GlobalKey<FormState>();
  final GameSessionClient _gameSessionClient;
  int _boardSize = 9;
  bool _isSuicideAllowed = false;
  final List<DropdownMenuItem<int>> _boardSizes = [
    DropdownMenuItem<int>(
      value: 9,
      child: Text("9x9"),
    ),
    DropdownMenuItem<int>(
      value: 13,
      child: Text("13x13"),
    ),
    DropdownMenuItem<int>(
      value: 19,
      child: Text("19x19"),
    ),
  ];

  _CreateGamePageView(this._gameSessionClient, this._userController);

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      body: Form(
          key: _formKey,
          child: Column(children: [
            ListTile(
              title: DropdownButton<int>(
                value: _boardSize,
                iconSize: 24,
                elevation: 16,
                onChanged: (int? boardSize) {
                  setState(() {
                    _boardSize = boardSize!;
                  });
                },
                items: _boardSizes,
                isExpanded: true,
              ),
              subtitle: Text(AppLocalizations.of(context)!.boardSize),
            ),
            ListTile(
              title: DropdownButton<bool>(
                value: _isSuicideAllowed,
                iconSize: 24,
                elevation: 16,
                onChanged: (bool? isSuicideAllowed) {
                  setState(() {
                    _isSuicideAllowed = isSuicideAllowed!;
                  });
                },
                items: _createSuicideAllowedChoices(context),
                isExpanded: true,
              ),
              subtitle: Text(AppLocalizations.of(context)!.isSuicideAllowed),
            ),
          ])),
      bottomActionBar: [
        BackButtonView(HomePageView(_gameSessionClient, _userController)),
        CreateGameButton(_gameSessionClient, _userController,
            SettingsModel(_boardSize, _isSuicideAllowed))
      ],
    );
  }

  List<DropdownMenuItem<bool>> _createSuicideAllowedChoices(
          BuildContext context) =>
      [
        DropdownMenuItem<bool>(
          value: true,
          child: Text(AppLocalizations.of(context)!.yes),
        ),
        DropdownMenuItem<bool>(
          value: false,
          child: Text(AppLocalizations.of(context)!.no),
        )
      ];
}
