import 'package:flutter/material.dart';
import 'package:go_app/theme/go_theme.dart';

class ClaySubHeadline extends StatelessWidget {
  final String text;

  const ClaySubHeadline(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    final theme = GoTheme.of(context);
    return Text(
      text,
      style: TextStyle(
        fontFamily: theme.fontFamily,
        fontSize: theme.fontSizeSubHeadline,
        color: theme.colorScheme.onSurface,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
