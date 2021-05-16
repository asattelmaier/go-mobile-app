import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_app/game/board/intersection/state/stone/stone_controller.dart';
import 'package:go_app/theme/go_theme.dart';

class StoneView extends StatelessWidget {
  final StoneController _controller;
  final GoTheme _theme;

  StoneView(this._controller, this._theme);

  @override
  Widget build(BuildContext context) => Container(
          decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _color,
      ));

  Color get _color => _controller.isBlack ? _theme.primaryDark : _theme.primaryLight;
}
