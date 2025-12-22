import 'package:flutter/widgets.dart';
import 'package:go_app/l10n/generated/app_localizations.dart';

enum BotDifficulty {
  easy,
  medium,
  hard;

  String toDtoValue() {
    return name.toUpperCase();
  }

  String localizedName(BuildContext context) {
    switch (this) {
      case BotDifficulty.easy:
        return AppLocalizations.of(context)!.easy;
      case BotDifficulty.medium:
        return AppLocalizations.of(context)!.medium;
      case BotDifficulty.hard:
        return AppLocalizations.of(context)!.hard;
    }
  }
}
