import 'package:flutter/material.dart';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;
import 'package:project_charon/views/home_page.dart';

// Dummy HomePage, you can replace it with your real HomePage

class SignupPage extends StatefulWidget {
  final Account account;
  final VoidCallback onToggle; // <-- Add this

  const SignupPage({super.key, required this.account, required this.onToggle});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  Future<void> signup(String email, String password, String name) async {
    try {
      // Create the user account
      await widget.account.create(
        userId: ID.unique(),
        email: email,
        password: password,
        name: name,
      );

      // Immediately login after signup
      await widget.account.createEmailPasswordSession(
        email: email,
        password: password,
      );

      // Navigate to HomePage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } on AppwriteException catch (e) {
      // Handle signup error
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Signup failed: ${e.message}')));
    } catch (e) {
      // Handle other errors
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('An unexpected error occurred')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            SizedBox(height: 16.0),
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
            SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: () {
                signup(
                  emailController.text.trim(),
                  passwordController.text.trim(),
                  nameController.text.trim(),
                );
              },
              child: Text('Sign Up'),
            ),
            SizedBox(height: 16.0),
            TextButton(
              onPressed: widget.onToggle, // <-- call toggle when clicked
              child: Text('Already have an account? Login'),
            ),
          ],
        ),
      ),
    );
  }
}
