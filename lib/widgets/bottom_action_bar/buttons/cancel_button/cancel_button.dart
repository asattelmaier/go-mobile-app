import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class CancelButtonView extends StatelessWidget {
  final VoidCallback _onPressed;

  const CancelButtonView(this._onPressed);

  @override
  Widget build(BuildContext context) => TextButton.icon(
        label: Text(AppLocalizations.of(context)!.cancel),
        icon: Icon(Icons.cancel_outlined),
        onPressed: _onPressed,
      );
}
