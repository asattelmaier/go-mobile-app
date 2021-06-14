import 'package:flutter/material.dart';
import 'package:go_app/theme/go_theme.dart';

class BottomActionBarView extends StatelessWidget {
  final List<Widget> _buttons;
  final MainAxisAlignment _alignment;

  const BottomActionBarView(this._buttons, this._alignment);

  @override
  Widget build(BuildContext context) {
    final gutter = GoTheme.of(context).gutter;

    return BottomAppBar(
        child: Padding(
      padding: EdgeInsets.only(
          top: gutter, bottom: gutter, left: gutter * 2, right: gutter * 2),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: _alignment,
        children: _buttons,
      ),
    ));
  }
}
