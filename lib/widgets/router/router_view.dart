import 'package:flutter/material.dart';

class RouterView extends StatelessWidget {
  final Widget _route;

  const RouterView(this._route);

  @override
  Widget build(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => _route));

    return new Container();
  }
}
