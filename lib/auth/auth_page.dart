import 'package:flutter/material.dart';
import 'package:appwrite/appwrite.dart';

import 'login_page.dart';
import 'signup_page.dart'; // Make sure you create separate files for them if you want cleaner code.

class AuthPage extends StatefulWidget {
  final Account account;
  const AuthPage({super.key, required this.account});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool showLogin = true; // Start by showing login

  void togglePages() {
    setState(() {
      showLogin = !showLogin;
    });
  }

  @override
  Widget build(BuildContext context) {
    return showLogin
        ? LoginPage(account: widget.account, onToggle: togglePages)
        : SignupPage(account: widget.account, onToggle: togglePages);
  }
}
