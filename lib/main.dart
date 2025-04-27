import 'package:flutter/material.dart';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;
import 'package:project_charon/auth/auth_page.dart';
import 'package:project_charon/auth/login_page.dart';
import 'package:project_charon/themes/theme_provider.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Client client = Client()
      .setEndpoint("https://fra.cloud.appwrite.io/v1")
      .setProject("680df948001ab4474ff0");
  Account account = Account(client);

  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: MyApp(account: account),
    ),
  );
}

class MyApp extends StatelessWidget {
  final Account account;

  const MyApp({super.key, required this.account});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: Provider.of<ThemeProvider>(context).themeData,
      home: AuthPage(account: account), // Use AuthPage here
    );
  }
}
