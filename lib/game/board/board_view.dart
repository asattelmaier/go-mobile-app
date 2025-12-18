import 'package:flutter/material.dart';
import 'package:go_app/game/board/board_controller.dart';
import 'package:go_app/game/board/intersection/intersection_controller.dart';
import 'package:go_app/game/board/intersection/intersection_view.dart';
import 'package:go_app/theme/go_theme.dart';

class BoardView extends StatelessWidget {
  // TODO: Create Theme for border width and colors
  final BoardController _controller;
  final double _width;

  const BoardView(this._controller, this._width);

  @override
  Widget build(BuildContext context) {
    final theme = GoTheme.of(context);

    if (_controller.isBoardEmpty) {
      return Container();
    }

    return Container(
      width: _width,
      height: _width,
      child: Container(
        color: theme.boardColor,
        child: Padding(
            padding: EdgeInsets.all(theme.gutter * 2),
            child: Stack(children: [
              _createGrid(theme),
              _intersections,
            ])),
      ),
    );
  }

  Widget _createGrid(GoTheme theme) => Center(
      child: Padding(
          padding: EdgeInsets.all(_width / _controller.size / 2),
          child: Stack(
            children: [
              _createVerticalLines(theme),
              _createHorizontalLines(theme),
            ],
          )));

  Widget get _intersections => Row(
        children: _controller.intersections
            .map((intersections) => Flexible(
                child: Column(
                    children: intersections
                        .map((intersection) => IntersectionView(
                              IntersectionController(_controller, intersection),
                            ))
                        .toList())))
            .toList(),
      );

  Widget _createVerticalLines(GoTheme theme) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: _createLines(Flexible(
            child: Container(
          width: theme.borderWidth,
          color: theme.colorScheme.surface,
        ))),
      );

  Widget _createHorizontalLines(GoTheme theme) => Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: _createLines(Flexible(
            child: Container(
          color: theme.colorScheme.surface,
          height: theme.borderWidth,
        ))),
      );

  List<Widget> _createLines(Widget widget) =>
      List.generate(_controller.size, (_) => widget);
}
