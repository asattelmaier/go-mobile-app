import 'package:flutter/cupertino.dart';
import 'package:go_app/game/board/intersection/state/state_controller.dart';
import 'package:go_app/game/board/intersection/state/stone/stone_controller.dart';
import 'package:go_app/game/board/intersection/state/stone/stone_view.dart';
import 'package:go_app/theme/go_theme.dart';

class StateView extends StatelessWidget {
  final StateController _controller;
  final GoTheme _theme;

  StateView(this._controller, this._theme);

  @override
  Widget build(BuildContext context) {
    if (_controller.isEmpty) {
      return Container();
    }

    return Padding(
        padding: EdgeInsets.all(2.0),
        child: StoneView(StoneController(_controller.stone), _theme));
  }
}
