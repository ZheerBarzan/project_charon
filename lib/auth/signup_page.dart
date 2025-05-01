import 'package:flutter/material.dart';
import 'package:appwrite/appwrite.dart';
import 'package:debtology/views/navigation/home_page.dart';

// Dummy HomePage, you can replace it with your real HomePage

class SignupPage extends StatefulWidget {
  final Account account;
  final VoidCallback onTap;
  const SignupPage({super.key, required this.account, required this.onTap});

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
        MaterialPageRoute(
          builder: (context) => HomePage(account: widget.account),
        ),
      );
    } on AppwriteException catch (e) {
      // Show more detailed error message
      print('Signup error code: ${e.code}');
      print('Signup error message: ${e.message}');
      print('Signup error type: ${e.type}');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Signup failed: ${e.message} (Code: ${e.code})'),
        ),
      );
    } catch (e) {
      // Handle other errors
      print('Unexpected error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An unexpected error occurred: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // Logo or App Name
                Image.asset('lib/assets/images/logo.png', height: 100),
                const SizedBox(height: 50),
                // Signup Form
                Text(
                  'Create an Account',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.normal,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 50),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'Name'),
                ),
                SizedBox(height: 20.0),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                ),
                SizedBox(height: 20.0),
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
                    signup(
                      emailController.text.trim(),
                      passwordController.text.trim(),
                      nameController.text.trim(),
                    );
                  },
                  child: Text(
                    'Sign Up',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.surface,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                TextButton(
                  onPressed: widget.onTap,
                  child: const Text("Already have an account? Login"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
