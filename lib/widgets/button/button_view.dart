import 'package:flutter/material.dart' hide Router;
import 'package:go_app/theme/go_theme.dart';

class ButtonView extends StatefulWidget {
  final Text text;
  final LinearGradient backgroundGradient;
  final double? height;

  ButtonView(
      {required this.text, required this.backgroundGradient, this.height});

  @override
  _ButtonViewState createState() =>
      _ButtonViewState(this.text, this.backgroundGradient, this.height);
}

class _ButtonViewState extends State<ButtonView> {
  bool isPressed = false;
  final Text _text;
  final LinearGradient _backgroundGradient;
  final double? _height;

  _ButtonViewState(this._text, this._backgroundGradient, this._height);

  @override
  Widget build(BuildContext context) {
    final theme = GoTheme.of(context);
    final gutter = theme.gutter;

    BoxShadow shadow = BoxShadow(
      color: Colors.black.withOpacity(0.7),
      offset: Offset(0, gutter),
      blurRadius: gutter * 3,
    );

    BoxShadow pressedShadow = BoxShadow(
      color: Colors.black.withOpacity(0.5),
      offset: Offset(0, gutter),
      blurRadius: gutter * .5,
    );

    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          isPressed = true;
        });
      },
      onTapUp: (_) {
        setState(() {
          isPressed = false;
        });
      },
      onTapCancel: () {
        setState(() {
          isPressed = false;
        });
      },
      child: AnimatedContainer(
          height: _height ?? gutter * 20,
          duration: Duration(milliseconds: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(_height ?? gutter * 20),
            gradient: _backgroundGradient,
            boxShadow: [isPressed ? pressedShadow : shadow],
          ),
          clipBehavior: Clip.hardEdge,
          child: Stack(children: [
            ..._background,
            Center(
              child: _text,
            ),
          ])),
    );
  }

  List<Widget> get _background {
    if (isPressed) {
      return [];
    }

    return [
      Align(
        alignment: Alignment.centerLeft,
        child: Image.asset("lib/widgets/button/assets/button_left.png"),
      ),
      Align(
        alignment: Alignment.centerRight,
        child: Image.asset("lib/widgets/button/assets/button_right.png"),
      ),
      Positioned.fill(
        child: Image.asset("lib/widgets/button/assets/button_center.png",
            repeat: ImageRepeat.repeat),
      ),
    ];
  }
}
