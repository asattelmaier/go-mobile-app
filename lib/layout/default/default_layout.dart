import 'package:flutter/material.dart';
import 'package:go_app/theme/go_theme.dart';
import 'package:go_app/widgets/bottom_action_bar/bottom_action_bar_view.dart';

class DefaultLayout extends StatelessWidget {
  final Widget body;
  final List<Widget> bottomActionBar;
  final MainAxisAlignment bottomActionBarAlignment;

  const DefaultLayout(
      {required this.body,
      this.bottomActionBar = const [],
      this.bottomActionBarAlignment = MainAxisAlignment.spaceBetween});

  @override
  Widget build(BuildContext context) {
    final theme = GoTheme.of(context);

    return Scaffold(
      backgroundColor: theme.backgroundColor,
      body: SafeArea(child: body),
      bottomNavigationBar: _bottomActionBar,
    );
  }

  BottomActionBarView get _bottomActionBar {
    return BottomActionBarView(bottomActionBar, bottomActionBarAlignment);
  }
}
