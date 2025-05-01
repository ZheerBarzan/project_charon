import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;
import 'package:flutter/material.dart';
import 'package:debtology/auth/auth_page.dart';

class ProfilePage extends StatelessWidget {
  final Account account;
  final models.User? user; // Store user details here
  const ProfilePage({super.key, this.user, required this.account});

  void logout(BuildContext context) async {
    await account.deleteSession(sessionId: 'current');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => AuthPage(account: account)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            Spacer(),
            // Profile Header
            CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primary,
              radius: 30,
              child: Text(
                user!.name.substring(0, 1).toUpperCase(),
                style: const TextStyle(fontSize: 24, color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Hello, ${user!.name}',
              style: TextStyle(
                fontSize: 18,
                color: Theme.of(context).colorScheme.inverseSurface,
              ),
            ),
            const SizedBox(height: 20),

            // User email
            Text(
              user!.email,
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).colorScheme.inverseSurface,
              ),
            ),

            const SizedBox(height: 50),

            // logout button
            ElevatedButton(
              onPressed: () => logout(context),
              child: const Text("Logout"),
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
            ),
            Spacer(),
            Center(child: Text("Made by Zheer Barzan with Flutter 💙")),
          ],
        ),
      ),
    );
  }
}
