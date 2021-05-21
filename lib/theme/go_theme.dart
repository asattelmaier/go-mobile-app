import 'package:flutter/material.dart';

class GoTheme extends InheritedWidget {
  final double borderWidth = 2;

  final double gutter = 4;

  Color get boardColor => Color.fromRGBO(217, 145, 82, 1);

  Color get blackStoneColor => colorScheme.secondary;

  Color get whiteStoneColor => colorScheme.background;

  ColorScheme get colorScheme => ColorScheme(
      primary: Color.fromRGBO(107, 191, 23, 1),
      primaryVariant: Color.fromRGBO(79, 135, 28, 1.0),
      secondary: Color.fromRGBO(76, 79, 89, 1),
      secondaryVariant: Color.fromRGBO(132, 139, 149, 1.0),
      surface: Color.fromRGBO(76, 79, 89, 1.0),
      background: Color.fromRGBO(242, 242, 240, 1.0),
      error: Colors.red,
      onPrimary: Color.fromRGBO(242, 242, 240, 1.0),
      onSecondary: Color.fromRGBO(242, 242, 240, 1.0),
      onSurface: Color.fromRGBO(76, 79, 89, 1),
      onBackground: Color.fromRGBO(76, 79, 89, 1),
      onError: Color.fromRGBO(242, 242, 240, 1.0),
      brightness: Brightness.light);

  ThemeData get themeData => ThemeData(
        colorScheme: colorScheme,
        bottomAppBarColor: colorScheme.secondary,
        textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(primary: colorScheme.primary)),
      );

  const GoTheme({
    Key? key,
    required Widget child,
  }) : super(key: key, child: child);

  static GoTheme of(BuildContext context) {
    final GoTheme? result =
        context.dependOnInheritedWidgetOfExactType<GoTheme>();
    assert(result != null, 'No GoTheme found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(_) => false;
}
