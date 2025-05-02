import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

extension ContextExtensions on BuildContext {
  // Easy access to localizations
  AppLocalizations get l10n => AppLocalizations.of(this)!;

  // Easy access to theme
  ThemeData get theme => Theme.of(this);

  // Easy access to screen size
  Size get screenSize => MediaQuery.of(this).size;

  // Easy access to text styles
  TextTheme get textTheme => Theme.of(this).textTheme;
}
