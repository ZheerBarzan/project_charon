// lib/views/debtors_page.dart
import 'package:flutter/material.dart';
import 'package:project_charon/model/debtor.dart';
import 'package:project_charon/services/database_service.dart';
import 'package:project_charon/views/debtor_detail_page.dart';
import 'package:project_charon/views/add_debtor_page.dart';
import 'package:provider/provider.dart';

class DebtorsPage extends StatefulWidget {
  final String? userId;
  const DebtorsPage({super.key, this.userId});

  @override
  State<DebtorsPage> createState() => _DebtorsPageState();
}

class _DebtorsPageState extends State<DebtorsPage> {
  late DatabaseService _databaseService;
  bool _isLoading = true;
  List<Debtor> _debtors = [];
  List<Debtor> _filteredDebtors = []; // Add this line for filtered list

  @override
  void initState() {
    super.initState();
    _databaseService = Provider.of<DatabaseService>(context, listen: false);
    _loadDebtors();
  }

  Future<void> _loadDebtors() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final debtorsData =
          widget.userId != null
              ? await _databaseService.getDebtorsForUser(widget.userId!)
              : await _databaseService
                  .getAllDebtors(); // Fallback to all debtors if userId is null

      setState(() {
        _debtors =
            debtorsData.documents
                .map((doc) => Debtor.fromMap(doc.data))
                .toList();
        _filteredDebtors = _debtors;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading debtors: $e');
      setState(() {
        _isLoading = false;
        _debtors = []; // Ensure we have an empty list rather than null
        _filteredDebtors = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Debtors'),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadDebtors),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextFormField(
              decoration: InputDecoration(
                labelText: 'Search debtors',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                // Filter the list based on search term
                setState(() {
                  _filteredDebtors =
                      _debtors
                          .where(
                            (debtor) => debtor.name.toLowerCase().contains(
                              value.toLowerCase(),
                            ),
                          )
                          .toList();
                });
              },
            ),
          ),
          Expanded(
            child:
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _filteredDebtors.isEmpty
                    ? const Center(
                      child: Text('No debtors found. Add one to get started!'),
                    )
                    : ListView.builder(
                      itemCount: _filteredDebtors.length,
                      itemBuilder: (context, index) {
                        final debtor = _filteredDebtors[index];
                        return ListTile(
                          title: Text(debtor.name),
                          subtitle: Text(
                            debtor.phoneNumber ?? 'No phone number',
                          ),
                          trailing: Text(
                            '${debtor.currentBalance} ${debtor.currency}',
                            style: TextStyle(
                              color:
                                  debtor.currentBalance > 0
                                      ? Colors.red
                                      : Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) =>
                                        DebtorDetailPage(debtorId: debtor.id),
                              ),
                            ).then((_) => _loadDebtors());
                          },
                        );
                      },
                    ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddDebtorPage(userId: widget.userId),
            ),
          ).then((_) => _loadDebtors());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
