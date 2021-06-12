import 'package:flutter/material.dart';
import 'package:go_app/theme/go_theme.dart';
import 'package:go_app/widgets/bottom_action_bar/bottom_action_bar_view.dart';

class DefaultLayout extends StatelessWidget {
  final Widget body;
  final List<Widget> bottomActionBar;

  const DefaultLayout({required this.body, this.bottomActionBar = const []});

  @override
  Widget build(BuildContext context) {
    final theme = GoTheme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: SafeArea(child: body),
      bottomNavigationBar: _bottomActionBar,
    );
  }

  BottomActionBarView get _bottomActionBar {
    return BottomActionBarView(bottomActionBar);
  }
}
