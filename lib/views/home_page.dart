// Update in lib/views/home_page.dart
import 'package:flutter/material.dart';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:project_charon/views/debtors_page.dart';
import 'package:project_charon/views/mange_debtor.dart';
import 'package:project_charon/views/profile_page.dart';
import 'package:project_charon/views/settings_page.dart'; // Add this import

class HomePage extends StatefulWidget {
  final Account account;
  final models.User? user;

  const HomePage({super.key, required this.account, this.user});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  void goToPages(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  AppBar _buildAppBar() {
    switch (_currentIndex) {
      case 0:
        return AppBar(
          title: Center(child: Text("Hello ${widget.user?.name}")),
          elevation: 1,
        );
      case 1:
        return AppBar(
          title: Center(child: const Text("Debtors List")),
          elevation: 1,
        );
      case 2:
        return AppBar(
          title: Center(child: const Text("Settings")),
          elevation: 1,
        );
      case 3:
        return AppBar(
          title: Center(child: const Text("Profile")),
          elevation: 1,
        );
      default:
        return AppBar();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (widget.user?.name == null) {
      return const Scaffold(body: Center(child: Text("User not found")));
    }
    List<Widget> pages = [
      const MangeDebtor(),
      const DebtorsPage(),
      const SettingsPage(),
      ProfilePage(user: widget.user!, account: widget.account),
    ];
    return Scaffold(
      appBar: _buildAppBar(),
      body: pages[_currentIndex],

      bottomNavigationBar: Container(
        color: Theme.of(context).colorScheme.surface,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: GNav(
            backgroundColor: Theme.of(context).colorScheme.surface,
            gap: 8,
            onTabChange: (index) => goToPages(index),
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            tabs: [
              GButton(
                borderRadius: BorderRadius.circular(25),
                icon: Icons.home,
                backgroundColor: Theme.of(context).colorScheme.primary,
                iconActiveColor: Theme.of(context).colorScheme.surface,
                iconColor: Theme.of(context).colorScheme.inverseSurface,
                text: "Home",
                textColor: Theme.of(context).colorScheme.surface,
              ),
              GButton(
                borderRadius: BorderRadius.circular(25),
                icon: Icons.list,
                backgroundColor: Theme.of(context).colorScheme.primary,
                iconActiveColor: Theme.of(context).colorScheme.surface,
                iconColor: Theme.of(context).colorScheme.inverseSurface,
                text: "Debtors",
                textColor: Theme.of(context).colorScheme.surface,
              ),
              GButton(
                borderRadius: BorderRadius.circular(25),
                icon: Icons.settings_outlined,
                backgroundColor: Theme.of(context).colorScheme.primary,
                iconActiveColor: Theme.of(context).colorScheme.surface,
                iconColor: Theme.of(context).colorScheme.inverseSurface,
                text: "Settings",
                textColor: Theme.of(context).colorScheme.surface,
              ),
              GButton(
                borderRadius: BorderRadius.circular(25),
                icon: Icons.person,
                backgroundColor: Theme.of(context).colorScheme.primary,
                iconActiveColor: Theme.of(context).colorScheme.surface,
                iconColor: Theme.of(context).colorScheme.inverseSurface,
                text: "Profile",
                textColor: Theme.of(context).colorScheme.surface,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
