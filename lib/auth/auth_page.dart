import 'package:flutter/material.dart';
import 'package:appwrite/appwrite.dart';
import 'package:project_charon/auth/login_page.dart';
import 'package:project_charon/auth/signup_page.dart';

class AuthPage extends StatefulWidget {
  final Account account;
  const AuthPage({super.key, required this.account});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool showLoginPage = true;

  void togglePages() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return LoginPage(account: widget.account, onTap: togglePages);
    } else {
      return SignupPage(account: widget.account, onTap: togglePages);
    }
  }
}
