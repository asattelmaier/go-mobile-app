import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_app/game/board/intersection/intersection_controller.dart';

class IntersectionView extends StatelessWidget {
  static const double BORDER_WIDTH = 1;
  final IntersectionController _controller;

  IntersectionView(this._controller);

  @override
  Widget build(BuildContext context) => Flexible(
        child: GestureDetector(
            onTap: () {
              _controller.play();
            },
            child: Container(
                decoration: BoxDecoration(
              border: Border.all(
                  color: Colors.red, width: IntersectionView.BORDER_WIDTH),
            ))),
      );
}
