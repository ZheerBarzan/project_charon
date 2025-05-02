// lib/l10n/app_localizations.dart - Corrected with proper imports
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart' as gen;

// This is a wrapper around the generated AppLocalizations class
class AppLocalizations {
  static const LocalizationsDelegate<gen.AppLocalizations> delegate =
      gen.AppLocalizations.delegate;

  static gen.AppLocalizations of(BuildContext context) {
    return gen.AppLocalizations.of(context)!;
  }

  // Add these getters to access the localization delegates and supported locales
  static get localizationsDelegates => [
    gen.AppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ];

  static get supportedLocales => const [
    Locale('en'), // English
    Locale('ar'), // Arabic
    Locale('ku'), // Kurdish
  ];
}
