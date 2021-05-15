import 'package:flutter/cupertino.dart';
import 'package:go_app/game/board/intersection/state/state_controller.dart';
import 'package:go_app/game/board/intersection/state/stone/stone_controller.dart';
import 'package:go_app/game/board/intersection/state/stone/stone_view.dart';

class StateView extends StatelessWidget {
  final StateController _controller;

  StateView(this._controller);

  @override
  Widget build(BuildContext context) {
    if (_controller.isEmpty) {
      return Container();
    }

    return Padding(
        padding: EdgeInsets.all(2.0),
        child: StoneView(StoneController(_controller.stone)));
  }
}
