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
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                // Logo or App Name
                FlutterLogo(size: 100),
                const SizedBox(height: 50),
                Text(
                  'Welcome Back',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.normal,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 50),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                ),
                SizedBox(height: 30.0),
                TextField(
                  controller: passwordController,
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                ),
                SizedBox(height: 50.0),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 100.0,
                      vertical: 15.0,
                    ),
                  ),
                  onPressed: () {
                    login(emailController.text, passwordController.text);
                  },
                  child:
                      _isLoginInProgress
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text(
                            'Login',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                ),
                const SizedBox(height: 16.0),
                TextButton(
                  onPressed: widget.onTap,

                  child: Text("Don't have an account? Sign up"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
