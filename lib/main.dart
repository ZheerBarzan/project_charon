// Update in lib/main.dart
import 'package:flutter/material.dart';
import 'package:appwrite/appwrite.dart';
import 'package:project_charon/auth/auth_page.dart';
import 'package:project_charon/views/navigation/home_page.dart';
import 'package:project_charon/themes/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:project_charon/services/database_service.dart';
import 'package:appwrite/models.dart' as models;

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Appwrite client and account
  Client client = Client()
      .setEndpoint("https://fra.cloud.appwrite.io/v1")
      .setProject("680df948001ab4474ff0");
  Account account = Account(client);
  Databases databases = Databases(client);

  // Initialize DatabaseService
  DatabaseService databaseService = DatabaseService(databases: databases);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
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

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Debt Collector',
      theme: Provider.of<ThemeProvider>(context).themeData,
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
