import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_app/game/board/intersection/state/stone/stone_controller.dart';
import 'package:go_app/theme/go_theme.dart';

class StoneView extends StatelessWidget {
  static const String _BG_IMG =
      "lib/game/board/intersection/state/stone/assets/stone_bg.png";

  final StoneController _controller;
  final GoTheme _theme;

  StoneView(this._controller, this._theme);

  @override
  Widget build(BuildContext context) => Container(
      decoration: BoxDecoration(
          color: _color,
          shape: BoxShape.circle,
          image:
              DecorationImage(image: AssetImage(_BG_IMG), fit: BoxFit.cover)));

  Color get _color =>
      _controller.isBlack ? _theme.primaryDark : _theme.primaryLight;
}
