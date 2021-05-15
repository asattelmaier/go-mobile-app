import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_app/game/board/intersection/state/stone/stone_controller.dart';

class StoneView extends StatelessWidget {
  final StoneController _controller;

  StoneView(this._controller);

  @override
  Widget build(BuildContext context) => Container(
          decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _color,
      ));

  Color get _color => _controller.isBlack ? Colors.black : Colors.white;
}
