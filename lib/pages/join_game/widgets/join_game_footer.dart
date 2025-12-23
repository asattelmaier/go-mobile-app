import 'package:flutter/material.dart' hide Router;
import 'package:go_app/l10n/generated/app_localizations.dart';
import 'package:go_app/theme/go_theme.dart';
import 'package:go_app/widgets/clay_button/clay_button.dart';

class JoinGameFooter extends StatelessWidget {
  final VoidCallback onTapBack;
  final VoidCallback onTapJoin;

  const JoinGameFooter({
    Key? key,
    required this.onTapBack,
    required this.onTapJoin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = GoTheme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 20.0),
          child: ClayButton(
            text: l10n.back,
            color: theme.colorScheme.surface,
            textColor: theme.colorScheme.onSurface,
            width: 140,
            onTap: onTapBack,
          ),
        ),
        ClayButton(
          text: l10n.join,
          color: theme.colorScheme.primary,
          textColor: theme.colorScheme.onPrimary,
          width: 140,
          onTap: onTapJoin,
        ),
      ],
    );
  }
}
