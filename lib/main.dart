import 'package:flutter/material.dart' hide Router;
import 'package:go_app/api/key_chain/key_chain.dart';
import 'package:go_app/api/web_socket/web_socket_client.dart';
import 'package:go_app/configuration/configuration.dart';
import 'package:go_app/environment/environment.dart';
import 'package:go_app/game-session/client/game_session_client.dart';
import 'package:go_app/l10n/l10n.dart';
import 'package:go_app/pages/home/home_page_view.dart';
import 'package:go_app/pages/initial/initial_page_view.dart';
import 'package:go_app/theme/go_theme.dart';
import 'package:go_app/user/user_controller.dart';
import 'package:session_server_client/api.dart'; // ApiClient

main() async {
  final dependencies = await AppDependencies.initialize();
  runApp(GoApp(dependencies));
}

class AppDependencies {
  final GameSessionClient gameSessionClient;
  final UserController userController;
  final L10n l10n;

  AppDependencies._(this.gameSessionClient, this.userController, this.l10n);

  static Future<AppDependencies> initialize() async {
    final environment = Environment();
    final configuration = Configuration.create(environment);
    final url = configuration.backendUrl;
    final websocketUrl = configuration.websocketUrl;
    final keyChain = KeyChain();
    final apiClient =
        ApiClient(basePath: url.toString().replaceAll(RegExp(r'/$'), ''));
    final userController = await UserController.create(keyChain, apiClient);
    final l10n = L10n();
    final webSocketClient = WebSocketClient(websocketUrl);
    final gameSessionClient = await GameSessionClient.create(
        webSocketClient, apiClient, userController);

    return AppDependencies._(gameSessionClient, userController, l10n);
  }
}

class GoApp extends StatelessWidget {
  final AppDependencies _dependencies;

  const GoApp(this._dependencies);

  @override
  Widget build(_) {
    return GoTheme(child: Builder(
      builder: (BuildContext context) {
        final theme = GoTheme.of(context);

        return MaterialApp(
          theme: theme.themeData,
          localizationsDelegates: _dependencies.l10n.localizationDelegates,
          supportedLocales: _dependencies.l10n.supportedLocales,
          home: Container(
              color: theme.backgroundColor,
              child: Stack(children: [
                _dependencies.userController.isUserLoggedIn
                    ? HomePageView(_dependencies.gameSessionClient,
                        _dependencies.userController)
                    : InitialPageView(_dependencies.gameSessionClient,
                        _dependencies.userController),
              ])),
        );
      },
    ));
  }
}
