import 'package:flutter/material.dart';
import 'package:go_app/theme/go_theme.dart';
import 'package:go_app/utils/rect_tweens.dart';
import 'package:go_app/widgets/clay_text/clay_text.dart';

class ClayGoLogo extends StatelessWidget {
  const ClayGoLogo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = GoTheme.of(context);
    final size = MediaQuery.of(context).size;
    final fontSize = size.height * 0.22;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Hero(
          tag: 'hero_logo_g',
          createRectTween: (b, e) => BouncyRectTween(begin: b, end: e),
          child: ClayText(
            text: "G",
            baseColor: theme.colorScheme.primary,
            style: TextStyle(
              fontSize: fontSize,
              fontFamily: theme.fontFamily,
              fontWeight: FontWeight.w900,
              height: 1.0,
            ),
          ),
        ),
        Hero(
          tag: 'hero_logo_o',
          createRectTween: (b, e) => BouncyRectTween(begin: b, end: e),
          child: ClayText(
            text: "O",
            baseColor: theme.colorScheme.secondary,
            style: TextStyle(
              fontSize: fontSize,
              fontFamily: theme.fontFamily,
              fontWeight: FontWeight.w900,
              height: 1.0,
            ),
          ),
        ),
      ],
    );
  }
}
