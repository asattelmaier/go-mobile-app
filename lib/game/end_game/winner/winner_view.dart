import 'package:flutter/cupertino.dart';
import 'package:go_app/game/end_game/winner/winner_controller.dart';

class WinnerView extends StatelessWidget {
  final WinnerController _controller;

  WinnerView(this._controller);

  @override
  Widget build(_) => Text('Winner: ${_controller.winner}');
}
