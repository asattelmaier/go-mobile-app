import 'package:flutter/material.dart';
import 'package:go_app/game-session/client/game_session_client.dart';
import 'package:go_app/pages/initial/widgets/login_button/login_button_view.dart';
import 'package:go_app/pages/initial/widgets/play_as_guest_button/play_as_guest_button_view.dart';
import 'package:go_app/pages/initial/widgets/register_button/register_button_view.dart';
import 'package:go_app/theme/go_theme.dart';
import 'package:go_app/user/user_controller.dart';

class InitialPageView extends StatelessWidget {
  final GameSessionClient _gameSessionClient;
  final UserController _userController;

  InitialPageView(this._gameSessionClient, this._userController);

  @override
  Widget build(BuildContext context) {
    final theme = GoTheme.of(context);

    return Container(
      color: theme.colorScheme.secondary,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Image.asset("lib/pages/initial/assets/top_image.jpg"),
          ),
          Padding(
            padding: EdgeInsets.only(
                left: GoTheme.of(context).gutter * 10,
                right: GoTheme.of(context).gutter * 10,
                bottom: GoTheme.of(context).gutter * 20),
            child: Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    PlayAsGuestButtonView(_gameSessionClient, _userController),
                    SizedBox(height: theme.gutter * 10),
                    RegisterButtonView(),
                    SizedBox(height: theme.gutter * 10),
                    LoginButtonView(),
                  ],
                )),
          )
        ],
      ),
    );
  }
}
