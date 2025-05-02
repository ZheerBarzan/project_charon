import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart' as gen;

// This is a wrapper around the generated AppLocalizations class
class AppLocalizations {
  static const LocalizationsDelegate<gen.AppLocalizations> delegate =
      gen.AppLocalizations.delegate;

  static gen.AppLocalizations of(BuildContext context) {
    return gen.AppLocalizations.of(context)!;
  }
}
