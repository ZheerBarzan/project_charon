import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleProvider extends ChangeNotifier {
  Locale _locale = Locale('en');
  static const String _localeKey = 'locale_code';

  LocaleProvider() {
    _loadSavedLocale();
  }

  Locale get locale => _locale;

  // Load saved locale from preferences on app start
  Future<void> _loadSavedLocale() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final localeCode = prefs.getString(_localeKey);
      if (localeCode != null) {
        _locale = Locale(localeCode);
        notifyListeners();
      }
    } catch (e) {
      print('Error loading saved locale: $e');
    }
  }

  Future<void> setLocale(Locale locale) async {
    if (locale != _locale) {
      _locale = locale;
      notifyListeners();

      // Save selected locale to preferences
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_localeKey, locale.languageCode);
      } catch (e) {
        print('Error saving locale preference: $e');
      }
    }
  }
}
