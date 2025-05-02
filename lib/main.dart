import 'package:debtology/l10n/local_provider.dart';
import 'package:flutter/material.dart';
import 'package:appwrite/appwrite.dart';
import 'package:debtology/auth/auth_page.dart';
import 'package:debtology/views/navigation/home_page.dart';
import 'package:debtology/themes/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:debtology/services/database_service.dart';
import 'package:appwrite/models.dart' as models;
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// Helper extension for easier access to localizations
extension AppLocalizationsExtension on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Appwrite client and account
  Client client = Client()
      .setEndpoint("https://fra.cloud.appwrite.io/v1")
      .setProject("680df948001ab4474ff0")
      .setSelfSigned(status: true);
  Account account = Account(client);
  Databases databases = Databases(client);

  // Initialize DatabaseService
  DatabaseService databaseService = DatabaseService(databases: databases);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => LocaleProvider()),
        Provider.value(value: account),
        Provider.value(value: databaseService),
      ],
      child: MyApp(account: account, databaseService: databaseService),
    ),
  );
}

class MyApp extends StatelessWidget {
  final Account account;
  final DatabaseService databaseService;

  const MyApp({
    super.key,
    required this.account,
    required this.databaseService,
  });

  @override
  Widget build(BuildContext context) {
    // Initialize the database
    databaseService.initializeDatabase();

    final localeProvider = Provider.of<LocaleProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Debtology',
      theme: Provider.of<ThemeProvider>(context).themeData,
      locale: localeProvider.locale,
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'), // English
        Locale('ar'), // Arabic
        Locale('ku'), // Kurdish
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: FutureBuilder<models.User>(
        future: _getLoggedInUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (snapshot.hasData) {
            return HomePage(account: account, user: snapshot.data);
          } else {
            return AuthPage(account: account);
          }
        },
      ),
    );
  }

  Future<models.User> _getLoggedInUser() async {
    try {
      final user = await account.get();
      return user;
    } catch (e) {
      return Future.error('Not authenticated');
    }
  }
}
