import 'package:flutter/material.dart';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;
import 'package:project_charon/components/my_drawer.dart';

class HomePage extends StatelessWidget {
  final Account account;
  final models.User? user; // Receive user data here

  const HomePage({super.key, required this.account, this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      drawer: MyDrawer(account: account, user: user), // Pass user to drawer
      body: Center(child: const Text('Welcome to the Home Page!')),
    );
  }
}
