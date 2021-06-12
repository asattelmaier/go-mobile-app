import 'package:flutter/material.dart';
import 'package:go_app/theme/go_theme.dart';

class BottomActionBarView extends StatelessWidget {
  final List<Widget> _buttons;

  const BottomActionBarView(this._buttons);

  @override
  Widget build(BuildContext context) {
    final gutter = GoTheme.of(context).gutter;

    return BottomAppBar(
        child: Padding(
      padding: EdgeInsets.only(
          top: gutter, bottom: gutter, left: gutter * 2, right: gutter * 2),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: _buttons,
      ),
    ));
  }
}
