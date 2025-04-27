import 'package:flutter/material.dart';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;

class LoginPage extends StatefulWidget {
  final Account account;
  final VoidCallback onToggle; // <-- Add this

  const LoginPage({super.key, required this.account, required this.onToggle});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    try {
      final user = await widget.account.get();
      if (user != null) {
        // User is already logged in
        Navigator.pushReplacementNamed(context, '/home');
      }
    } catch (e) {
      // No active session or error, stay on login page
      print('No active session: $e');
    }
  }

  Future<void> login(String email, String password) async {
    try {
      await widget.account.createEmailPasswordSession(
        email: email,
        password: password,
      );
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      print('Login failed: $e');
      // Show a snackbar or dialog if you want
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                login(emailController.text, passwordController.text);
              },
              child: const Text('Login'),
            ),

            const SizedBox(height: 16),
            TextButton(
              onPressed: widget.onToggle, // <-- Call the toggle function
              child: const Text('Don\'t have an account? Sign up'),
            ),
          ],
        ),
      ),
    );
  }
}
