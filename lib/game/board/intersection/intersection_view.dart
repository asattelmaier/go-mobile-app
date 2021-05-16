import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_app/game/board/intersection/intersection_controller.dart';
import 'package:go_app/game/board/intersection/state/state_controller.dart';
import 'package:go_app/game/board/intersection/state/state_view.dart';
import 'package:go_app/theme/go_theme.dart';

class IntersectionView extends StatelessWidget {
  final IntersectionController _controller;
  final GoTheme _theme;

  IntersectionView(this._controller, this._theme);

  @override
  Widget build(_) => Flexible(
        child: GestureDetector(
            onTap: () {
              _controller.play();
            },
            child: Container(
                child: StateView(StateController(_controller.state), _theme),
                decoration: BoxDecoration())),
      );
}
