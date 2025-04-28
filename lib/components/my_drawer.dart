import 'package:flutter/material.dart';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;
import 'package:project_charon/views/debtors_page.dart';
import 'package:project_charon/auth/auth_page.dart';
import 'package:project_charon/views/settings_page.dart';

class MyDrawer extends StatelessWidget {
  final Account account;
  final models.User? user; // Store user details here

  const MyDrawer({super.key, required this.account, this.user});

  // Logout functionality
  void logout(BuildContext context) async {
    await account.deleteSession(sessionId: 'current');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => AuthPage(account: account)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              // Logo or Profile picture (show user's name if logged in)
              DrawerHeader(
                child:
                    user != null
                        ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                              radius: 30,
                              child: Text(
                                user!.name.substring(0, 1).toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 24,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Hello, ${user!.name}',
                              style: TextStyle(
                                fontSize: 18,
                                color:
                                    Theme.of(
                                      context,
                                    ).colorScheme.inverseSurface,
                              ),
                            ),
                          ],
                        )
                        : Icon(
                          Icons.account_circle,
                          color: Theme.of(context).colorScheme.primary,
                          size: 50,
                        ),
              ),
              // Home list tile
              Padding(
                padding: const EdgeInsets.only(left: 25),
                child: ListTile(
                  title: const Text("H O M E"),
                  leading: const Icon(Icons.home_outlined),
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
              // Settings list tile
              Padding(
                padding: const EdgeInsets.only(left: 25),
                child: ListTile(
                  title: const Text("S E T T I N G S"),
                  leading: const Icon(Icons.settings_outlined),
                  onTap: () {
                    // Add navigation to settings page if needed
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SettingsPage(),
                      ),
                    );
                  },
                ),
              ),
              // In lib/components/my_drawer.dart, add this to the Column of drawer items:
              Padding(
                padding: const EdgeInsets.only(left: 25),
                child: ListTile(
                  title: const Text("D E B T O R S"),
                  leading: const Icon(Icons.people_outline),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DebtorsPage(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          // If logged in, show logout button, otherwise show login button
          Padding(
            padding: const EdgeInsets.only(left: 25, bottom: 25),
            child: ListTile(
              title: Text(user != null ? "L O G O U T" : "L O G I N"),
              leading: Icon(user != null ? Icons.logout_outlined : Icons.login),
              onTap: () {
                if (user != null) {
                  logout(context);
                } else {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AuthPage(account: account),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
