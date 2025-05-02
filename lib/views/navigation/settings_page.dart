// lib/views/navigation/settings_page.dart - Updated version
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:debtology/themes/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:debtology/l10n/local_provider.dart';
import 'package:debtology/l10n/app_localizations.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Dark mode toggle
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).colorScheme.primary.withAlpha(50),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(AppLocalizations.of(context).darkMode),
                  CupertinoSwitch(
                    value: Provider.of<ThemeProvider>(context).isDarkMode,
                    onChanged: (value) {
                      Provider.of<ThemeProvider>(
                        context,
                        listen: false,
                      ).toggleThemeMode();
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Language selection
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).colorScheme.primary.withAlpha(50),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context).language,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 15),

                  // English option
                  _buildLanguageOption(
                    context,
                    AppLocalizations.of(context).english,
                    const Locale('en'),
                    localeProvider,
                  ),

                  const Divider(),

                  // Arabic option
                  _buildLanguageOption(
                    context,
                    AppLocalizations.of(context).arabic,
                    const Locale('ar'),
                    localeProvider,
                  ),

                  // const Divider(),

                  // Kurdish option
                  /* _buildLanguageOption(
                    context,
                    AppLocalizations.of(context).kurdish,
                    const Locale('ku'),
                    localeProvider,
                  ),*/
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageOption(
    BuildContext context,
    String languageName,
    Locale locale,
    LocaleProvider provider,
  ) {
    final isSelected = provider.locale.languageCode == locale.languageCode;

    return InkWell(
      onTap: () {
        provider.setLocale(locale);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(languageName),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: Theme.of(context).colorScheme.primary,
              ),
          ],
        ),
      ),
    );
  }
}
