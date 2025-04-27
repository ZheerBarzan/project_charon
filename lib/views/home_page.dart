import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:project_charon/components/my_drawer.dart';

class HomePage extends StatelessWidget {
  final Account? account;
  const HomePage({super.key, this.account});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home Page')),
      drawer: MyDrawer(account: account!),
      body: Center(child: const Text('Welcome to the Home Page!')),
    );
  }
}
