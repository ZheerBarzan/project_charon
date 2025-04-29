import 'package:flutter/material.dart';
import 'package:project_charon/views/debtors_page.dart';

class MangeDebtor extends StatelessWidget {
  const MangeDebtor({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 40),
          _buildFeatureCard(
            context,
            'Manage Debtors',
            'Track people who owe you money',
            Icons.people,
            () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const DebtorsPage()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(
    BuildContext context,
    String title,
    String description,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withAlpha(50),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Card(
        elevation: 10,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 48,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.inverseSurface,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
