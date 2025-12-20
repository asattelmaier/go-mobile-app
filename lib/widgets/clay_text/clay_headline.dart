import 'package:flutter/material.dart';
import 'package:go_app/theme/go_theme.dart';

class ClayHeadline extends StatelessWidget {
  final String text;

  const ClayHeadline(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    final theme = GoTheme.of(context);
    return Text(
      text,
      style: TextStyle(
        fontSize: theme.fontSizeHeadline,
        fontFamily: theme.fontFamily,
        fontWeight: FontWeight.w900,
        color: theme.colorScheme.onSurface,
        shadows: [
          Shadow(
            color: Colors.white.withValues(alpha: 0.5),
            offset: Offset(2, 2),
            blurRadius: 0,
          ),
        ],
      ),
    );
  }
}
