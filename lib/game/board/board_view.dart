import 'package:flutter/material.dart';
import 'package:go_app/game/board/board_controller.dart';
import 'package:go_app/game/board/intersection/intersection_controller.dart';
import 'package:go_app/game/board/intersection/intersection_view.dart';

class BoardView extends StatelessWidget {
  // TODO: Create Theme for border width and colors
  static const double BORDER_WIDTH = 2;
  static const Color BORDER_COLOR = Colors.white;
  final BoardController _controller;
  final double _width;

  BoardView(this._controller, this._width);

  @override
  Widget build(BuildContext context) {
    if (_controller.isBoardEmpty) {
      return Container();
    }

    return Container(
      width: _width,
      height: _width,
      decoration: BoxDecoration(
          image: DecorationImage(
        image: AssetImage("lib/game/board/assets/board_bg.jpg"),
        fit: BoxFit.cover,
      )),
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Container(
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
                            IntersectionController(_controller, intersection)))
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
          width: BORDER_WIDTH,
          color: BORDER_COLOR,
        ))),
      );

  Widget get _horizontalLines => Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: _createLines(Flexible(
            child: Container(
          color: BORDER_COLOR,
          height: BORDER_WIDTH,
        ))),
      );

  List<Widget> _createLines(Widget widget) =>
      List.generate(_controller.size, (_) => widget);
}
