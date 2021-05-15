import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_app/game/board/intersection/state/stone/stone_controller.dart';

class StoneView extends StatelessWidget {
  static const String BLACK_STONE_IMG =
      "lib/game/board/intersection/state/stone/assets/black_stone.png";

  static const String WHITE_STONE_IMG =
      "lib/game/board/intersection/state/stone/assets/white_stone.png";

  final StoneController _controller;

  StoneView(this._controller);

  @override
  Widget build(BuildContext context) => Container(
          decoration: BoxDecoration(
              image: DecorationImage(
        image: AssetImage(_img),
        fit: BoxFit.cover,
      )));

  String get _img => _controller.isBlack ? BLACK_STONE_IMG : WHITE_STONE_IMG;
}
