import 'package:flutter/material.dart';
import 'package:go_app/game/board/board_controller.dart';
import 'package:go_app/game/board/intersection/intersection_controller.dart';
import 'package:go_app/game/board/intersection/intersection_view.dart';

class BoardView extends StatelessWidget {
  // TODO: Create Theme for border width and colors
  static const double BORDER_WIDTH = 1;
  static const Color BORDER_COLOR = Colors.black;
  static const Color BOARD_COLOR = Colors.grey;
  final BoardController _controller;
  final double _width;

  BoardView(this._controller, this._width);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _width,
      height: _width,
      decoration: BoxDecoration(color: Colors.green),
      child: Stack(children: [
        if (!_controller.isBoardEmpty) _board,
        _intersections,
      ]),
    );
  }

  Widget get _board => Center(
          child: Container(
        width: _boardWidth,
        height: _boardWidth,
        child: _lines,
        decoration: BoxDecoration(color: BOARD_COLOR),
      ));

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

  double get _boardWidth => _width - (_width / _controller.size);
}
