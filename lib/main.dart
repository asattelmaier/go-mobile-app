import 'package:flutter/material.dart' hide Router;
import 'package:go_app/api/http/http_client.dart';
import 'package:go_app/api/local_storage/local_storage.dart';
import 'package:go_app/api/web_socket/web_socket_client.dart';
import 'package:go_app/configuration/configuration.dart';
import 'package:go_app/environment/environment.dart';
import 'package:go_app/game-session/client/game_session_client.dart';
import 'package:go_app/l10n/l10n.dart';
import 'package:go_app/pages/home/home_page_view.dart';
import 'package:go_app/theme/go_theme.dart';
import 'package:go_app/user/user_controller.dart';

main() async {
  final environment = Environment();
  final configuration = Configuration.create(environment);
  final url = configuration.backendUrl;
  final localStorage = LocalStorage();
  final httpClient = HttpClient(url);
  // TODO: It is not required to connect initially
  final webSocketClient = await WebSocketClient.connect(url);
  final gameSessionClient = GameSessionClient(webSocketClient, httpClient);
  final userController = await UserController.create(localStorage, httpClient);
  final l10n = L10n();

  runApp(GoApp(gameSessionClient, l10n, userController));
}

class GoApp extends StatelessWidget {
  final GameSessionClient _gameSessionClient;
  final UserController _userController;
  final L10n _l10n;

  const GoApp(this._gameSessionClient, this._l10n, this._userController);

  @override
  Widget build(_) {
    return GoTheme(child: Builder(
      builder: (BuildContext context) {
        final theme = GoTheme.of(context);

        return MaterialApp(
          theme: theme.themeData,
          localizationsDelegates: _l10n.localizationDelegates,
          supportedLocales: _l10n.supportedLocales,
          home: Container(
              color: theme.colorScheme.background,
              child: Stack(children: [
                HomePageView(_gameSessionClient, _userController),
              ])),
        );
      },
    ));
  }
}
