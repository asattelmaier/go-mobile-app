import 'package:flutter/material.dart' hide Router;
import 'package:go_app/l10n/generated/app_localizations.dart';
import 'package:go_app/theme/go_theme.dart';
import 'package:go_app/widgets/button/button_view.dart';

class LoginButtonView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = GoTheme.of(context);

    return ButtonView(
      height: theme.gutter * 20,
      text: Text(
        AppLocalizations.of(context)!.logIn,
        style: TextStyle(
          color: Color.fromRGBO(3, 7, 41, 1),
          fontSize: 30,
          fontFamily: theme.fontFamily,
          fontWeight: FontWeight.w600,
          decoration: TextDecoration.none,
        ),
      ),
      backgroundGradient: LinearGradient(
        colors: [
          Colors.white,
          Color.fromRGBO(255, 249, 220, 1),
          Color.fromRGBO(254, 234, 198, 1),
          Color.fromRGBO(250, 194, 152, 1),
        ],
        stops: [0, 0.1, 0.6, 1],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      onTab: () => null,
    );
  }
}
