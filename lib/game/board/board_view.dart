import 'package:flutter/material.dart';
import 'package:go_app/game/board/board_controller.dart';
import 'package:go_app/game/board/intersection/intersection_controller.dart';
import 'package:go_app/game/board/intersection/intersection_view.dart';
import 'package:go_app/theme/go_theme.dart';

class BoardView extends StatelessWidget {
  // TODO: Create Theme for border width and colors
  final BoardController _controller;
  final double _width;
  final GoTheme _theme;

  BoardView(this._controller, this._theme, this._width);

  @override
  Widget build(BuildContext context) {
    if (_controller.isBoardEmpty) {
      return Container();
    }

    return Container(
      width: _width,
      height: _width,
      child: Container(
        color: _theme.secondaryLight,
        child: Padding(
            padding: EdgeInsets.all(_theme.gutter * 2),
            child: Stack(children: [
              _grid,
              _intersections,
            ])),
      ),
    );
  }

  Widget get _grid => Center(
      child: Padding(
          padding: EdgeInsets.all(_width / _controller.size / 2),
          child: _lines));

  Widget get _intersections => Row(
        children: _controller.intersections
            .map((intersections) => Flexible(
                child: Column(
                    children: intersections
                        .map((intersection) => IntersectionView(
                            IntersectionController(_controller, intersection),
                            _theme))
                        .toList())))
            .toList(),
      );

  Widget get _lines => Stack(
        children: [
          _verticalLines,
          _horizontalLines,
        ],
      );

  Widget get _verticalLines => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: _createLines(Flexible(
            child: Container(
          width: _theme.borderWidth,
          color: _theme.primaryLight,
        ))),
      );

  Widget get _horizontalLines => Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: _createLines(Flexible(
            child: Container(
          color: _theme.primaryLight,
          height: _theme.borderWidth,
        ))),
      );

  List<Widget> _createLines(Widget widget) =>
      List.generate(_controller.size, (_) => widget);
}
