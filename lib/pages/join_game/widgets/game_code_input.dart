import 'package:flutter/material.dart';
import 'package:go_app/l10n/generated/app_localizations.dart';
import 'package:go_app/theme/go_theme.dart';

class GameCodeInput extends StatelessWidget {
  final TextEditingController controller;

  const GameCodeInput({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = GoTheme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Center(
      child: Container(
        width: 300,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.1),
            width: 2,
          ),
        ),
        child: TextField(
          controller: controller,
          style: TextStyle(
            fontFamily: theme.fontFamily,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: l10n.enterGameSessionId,
            hintStyle: TextStyle(
              fontFamily: theme.fontFamily,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
            icon: Icon(
              Icons.vpn_key_rounded,
              color: theme.colorScheme.primary,
            ),
          ),
        ),
      ),
    );
  }
}
