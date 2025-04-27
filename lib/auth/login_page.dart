import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:project_charon/views/home_page.dart';

class LoginPage extends StatefulWidget {
  final Account account;
  final VoidCallback onTap;

  const LoginPage({super.key, required this.account, required this.onTap});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isLoginInProgress = false;

  Future<void> login(String email, String password) async {
    if (_isLoginInProgress) return; // Don't allow multiple login attempts

    try {
      setState(() {
        _isLoginInProgress = true;
      });

      await widget.account.createEmailPasswordSession(
        email: email,
        password: password,
      );

      final user = await widget.account.get();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(account: widget.account),
        ),
      );
    } on AppwriteException catch (e) {
      setState(() {
        _isLoginInProgress = false;
      });

      if (e.code == 429) {
        // Rate limit exceeded, inform the user
        showDialog(
          context: context,
          builder:
              (context) => AlertDialog(
                title: Text("Rate Limit Exceeded"),
                content: Text(
                  "You have reached the rate limit. Please try again after some time.",
                ),
                actions: <Widget>[
                  TextButton(
                    child: Text("OK"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
        );
      } else {
        // Handle other errors (invalid credentials, etc.)
        showDialog(
          context: context,
          builder:
              (context) => AlertDialog(
                title: Text("Login Failed"),
                content: Text(
                  "An error occurred while logging in. Please try again.",
                ),
                actions: <Widget>[
                  TextButton(
                    child: Text("OK"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login Page')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                login(emailController.text, passwordController.text);
              },
              child:
                  _isLoginInProgress
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text('Login'),
            ),
            TextButton(
              onPressed: widget.onTap,

              child: Text("Don't have an account? Sign up"),
            ),
          ],
        ),
      ),
    );
  }
}
