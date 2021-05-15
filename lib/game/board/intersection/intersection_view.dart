import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_app/game/board/intersection/intersection_controller.dart';
import 'package:go_app/game/board/intersection/state/state_controller.dart';
import 'package:go_app/game/board/intersection/state/state_view.dart';

class IntersectionView extends StatelessWidget {
  static const double BORDER_WIDTH = 1;
  final IntersectionController _controller;

  IntersectionView(this._controller);

  @override
  Widget build(_) => Flexible(
        child: GestureDetector(
            onTap: () {
              _controller.play();
            },
            child: Container(
                child: StateView(StateController(_controller.state)),
                decoration: BoxDecoration())),
      );
}
