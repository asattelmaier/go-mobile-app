import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_app/game-session/game_session_controller.dart';
import 'package:go_app/game/settings/settings_model.dart';
import 'package:go_app/layout/default/default_layout.dart';
import 'package:go_app/pages/home/home_page_view.dart';
import 'package:go_app/widgets/bottom_action_bar/buttons/back_button/back_button.dart';
import 'package:go_app/widgets/bottom_action_bar/buttons/create_game_button/create_game_button_view.dart';

class CreateGamePageView extends StatefulWidget {
  final GameSessionController _gameSessionController;

  const CreateGamePageView(this._gameSessionController);

  @override
  State<CreateGamePageView> createState() =>
      _CreateGamePageView(_gameSessionController);
}

class _CreateGamePageView extends State<CreateGamePageView> {
  final _formKey = GlobalKey<FormState>();
  final GameSessionController _gameSessionController;
  int _boardSize = 19;
  bool _isSuicideAllowed = false;
  final List<DropdownMenuItem<int>> _boardSizes = [
    DropdownMenuItem<int>(
      value: 19,
      child: Text("19x19"),
    ),
    DropdownMenuItem<int>(
      value: 13,
      child: Text("13x13"),
    ),
    DropdownMenuItem<int>(
      value: 9,
      child: Text("9x9"),
    )
  ];

  _CreateGamePageView(this._gameSessionController);

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
        BackButtonView(HomePageView(_gameSessionController)),
        CreateGameButton(
            _gameSessionController, SettingsModel(_boardSize, _isSuicideAllowed))
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
