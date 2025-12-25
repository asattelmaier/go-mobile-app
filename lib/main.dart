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
  final dependencies = await AppDependencies.create();
  runApp(GoApp(dependencies));
}

class AppDependencies {
  final GameSessionClient gameSessionClient;
  final UserController userController;
  final L10n l10n;
  final ApiClient apiClient;

  AppDependencies._(
      this.gameSessionClient, this.userController, this.l10n, this.apiClient);

  factory AppDependencies.of(BuildContext context) {
    // Optional: if we used InheritedWidget/Provider, but for now just static access is removed.
    // For this refactor, we just focus on creating.
    throw UnimplementedError();
  }

  static Future<AppDependencies> create() async {
    final config = Configuration.create(Environment());
    final apiClient = ApiClient(
        basePath: config.backendUrl.toString().replaceAll(RegExp(r'/$'), ''));

    final userController = await UserController.create(KeyChain(), apiClient);

    final gameSessionClient = await GameSessionClient.create(
        WebSocketClient(config.websocketUrl), apiClient, userController);

    return AppDependencies._(
        gameSessionClient, userController, L10n(), apiClient);
  }

  void dispose() {
    gameSessionClient.disconnect();
    apiClient.client.close();
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
