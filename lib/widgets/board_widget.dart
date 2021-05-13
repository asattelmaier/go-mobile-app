import 'package:flutter/material.dart';
import 'package:go_app/game/board.dart';

class BoardWidget extends StatelessWidget {
  final Board _board;

  BoardWidget(this._board);

  // TODO: Make magic numbers configurable
  @override
  Widget build(BuildContext context) => AspectRatio(
        aspectRatio: 1.0,
        child: AnimatedContainer(
            duration: Duration(milliseconds: 300),
            margin: EdgeInsets.all(8.0),
            color: Colors.grey,
            child: Stack(
              children: <Widget>[
                _verticalLines(_board.rows),
                _horizontalLines(_board.rows),
              ],
            )),
      );

  Widget _verticalLines(int rows) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: _toList(rows)(Flexible(
            flex: 1,
            child: Container(
              width: 1,
              color: Colors.black,
              height: 400,
            ))),
      );

  Widget _horizontalLines(int rows) => Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: _toList(rows)(Flexible(
            flex: 1,
            child: Container(
              width: 400,
              color: Colors.black,
              height: 1,
            ))),
      );

  Function(Widget) _toList(int rows) =>
      (Widget widget) => List.generate(rows, (_) => widget);
}
