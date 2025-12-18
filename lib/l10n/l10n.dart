import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_app/l10n/generated/app_localizations.dart';

class L10n {
  final List<LocalizationsDelegate> localizationDelegates = [
    AppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ];

  final List<Locale> supportedLocales = [
    const Locale('en', ''),
    const Locale('de', ''),
  ];
}
