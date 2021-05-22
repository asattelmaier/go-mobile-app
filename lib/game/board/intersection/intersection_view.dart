import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_app/game/board/intersection/intersection_controller.dart';
import 'package:go_app/game/board/intersection/state/state_controller.dart';
import 'package:go_app/game/board/intersection/state/state_view.dart';

class IntersectionView extends StatelessWidget {
  final IntersectionController _controller;

  const IntersectionView(this._controller);

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
