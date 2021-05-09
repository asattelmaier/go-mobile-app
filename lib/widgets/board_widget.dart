import 'package:flutter/material.dart';

class BoardWidget extends StatelessWidget {
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
                _verticalLines,
                _horizontalLines,
              ],
            )),
      );

  Widget get _verticalLines => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: _toList(Container(
          width: 1,
          color: Colors.black,
          height: 400,
        )),
      );

  Widget get _horizontalLines => Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: _toList(Container(
          width: 400,
          color: Colors.black,
          height: 1,
        )),
      );

  List<Widget> _toList(Widget widget) => List.generate(19, (_) => widget);
}
