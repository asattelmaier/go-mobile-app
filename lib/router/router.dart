import 'package:flutter/material.dart';

class Router {
  static Future push(BuildContext context, Widget route) {
    return Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => route,
        transitionDuration: Duration(seconds: 0),
      ),
    );
  }
}
