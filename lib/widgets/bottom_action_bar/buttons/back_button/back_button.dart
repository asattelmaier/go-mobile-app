import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart' hide Router;
import 'package:go_app/router/router.dart';

class BackButtonView extends StatelessWidget {
  final Widget _route;

  const BackButtonView(this._route);

  @override
  Widget build(BuildContext context) => TextButton.icon(
        label: Text(AppLocalizations.of(context)!.back),
        icon: Icon(Icons.arrow_back_ios),
        onPressed: () => Router.push(context, _route),
      );
}
