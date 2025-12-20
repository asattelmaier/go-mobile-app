import 'package:flutter/material.dart';

class GoTheme extends InheritedWidget {
  final double borderWidth = 2;

  final double gutter = 4;

  final double fontSizeSmall = 12;

  final String fontFamily = "Fredoka";

  Color get backgroundColor => Color(0xFFFFD99B);

  Color get boardColor => Color.fromRGBO(217, 145, 82, 1);

  Color get blackStoneColor => colorScheme.secondary;

  Color get whiteStoneColor => backgroundColor;

  ColorScheme get colorScheme => ColorScheme(
      primary: Color(0xFFFFBF4D),
      primaryContainer: Color(0xFFF57C00),
      secondary: Color(0xFF26A69A),
      tertiary: Color(0xFFF19154),
      secondaryContainer: Color(0xFF00796B),
      surface: Color(0xFFFFD99B),
      background: Color(0xFFFFD99B),
      error: Color(0xFFD32F2F),
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Color(0xFF5D4037),
      onBackground: Color(0xFF5D4037),
      onError: Colors.white,
      brightness: Brightness.light);

  ThemeData get themeData => ThemeData(
        colorScheme: colorScheme,
        scaffoldBackgroundColor: backgroundColor,
        bottomAppBarTheme: BottomAppBarThemeData(color: colorScheme.secondary),
        textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(foregroundColor: colorScheme.primary)),
      );

  GoTheme({
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
