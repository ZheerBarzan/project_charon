import 'package:flutter/material.dart';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;
import 'package:project_charon/auth/login_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Client client = Client()
      .setEndpoint("https://fra.cloud.appwrite.io/v1")
      .setProject("680df948001ab4474ff0");
  Account account = Account(client);

  runApp(MaterialApp(home: MyApp(account: account)));
}

class MyApp extends StatelessWidget {
  final Account account;

  const MyApp({super.key, required this.account});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: LoginPage(
        account: Account(
          Client()
            ..setEndpoint('https://fra.cloud.appwrite.io/v1')
            ..setProject('680df948001ab4474ff0'),
        ),
      ),
    );
  }
}
