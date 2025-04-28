// lib/views/debtor_detail_page.dart
import 'package:flutter/material.dart';
import 'package:project_charon/model/debtor.dart';
import 'package:project_charon/model/transaction.dart';
import 'package:project_charon/services/database_service.dart';
import 'package:provider/provider.dart';
import 'package:project_charon/views/add_transaction_page.dart';
import 'package:intl/intl.dart';

class DebtorDetailPage extends StatefulWidget {
  final String debtorId;

  const DebtorDetailPage({super.key, required this.debtorId});

  @override
  State<DebtorDetailPage> createState() => _DebtorDetailPageState();
}

class _DebtorDetailPageState extends State<DebtorDetailPage> {
  late DatabaseService _databaseService;
  bool _isLoading = true;
  Debtor? _debtor;
  List<Transaction> _transactions = [];

  @override
  void initState() {
    super.initState();
    _databaseService = Provider.of<DatabaseService>(context, listen: false);
    _loadDebtorAndTransactions();
  }

  Future<void> _loadDebtorAndTransactions() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final debtorDoc = await _databaseService.getDebtor(widget.debtorId);
      final transactionsData = await _databaseService.getTransactionsForDebtor(
        widget.debtorId,
      );

      setState(() {
        _debtor = Debtor.fromMap(debtorDoc.data);
        _transactions =
            transactionsData.documents
                .map((doc) => Transaction.fromMap(doc.data))
                .toList();
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading debtor details: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteTransaction(Transaction transaction) async {
    try {
      await _databaseService.deleteTransaction(
        transaction.id,
        transaction.debtorId,
        transaction.amount,
      );
      _loadDebtorAndTransactions();
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Transaction deleted')));
      }
    } catch (e) {
      print('Error deleting transaction: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error deleting transaction: $e')),
        );
      }
    }
  }

  Future<void> _deleteDebtor() async {
    try {
      await _databaseService.deleteDebtor(widget.debtorId);
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Debtor deleted')));
      }
    } catch (e) {
      print('Error deleting debtor: $e');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error deleting debtor: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Debtor Details')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_debtor == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Debtor Details')),
        body: const Center(child: Text('Debtor not found')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_debtor!.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              showDialog(
                context: context,
                builder:
                    (context) => AlertDialog(
                      title: const Text('Delete Debtor'),
                      content: const Text(
                        'Are you sure you want to delete this debtor? This will also delete all associated transactions.',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            _deleteDebtor();
                          },
                          child: const Text('Delete'),
                        ),
                      ],
                    ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Debtor info card
          Card(
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Current Balance:',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Text(
                        '${_debtor!.currentBalance} ${_debtor!.currency}',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color:
                              _debtor!.currentBalance > 0
                                  ? Colors.red
                                  : Colors.green,
                        ),
                      ),
                    ],
                  ),
                  if (_debtor!.phoneNumber != null) ...[
                    const SizedBox(height: 8),
                    Text('Phone: ${_debtor!.phoneNumber}'),
                  ],
                  if (_debtor!.note != null && _debtor!.note!.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text('Note: ${_debtor!.note}'),
                  ],
                ],
              ),
            ),
          ),

          // Transactions list header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Transactions',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                TextButton.icon(
                  icon: const Icon(Icons.refresh),
                  label: const Text('Refresh'),
                  onPressed: _loadDebtorAndTransactions,
                ),
              ],
            ),
          ),

          // Transactions list
          Expanded(
            child:
                _transactions.isEmpty
                    ? const Center(child: Text('No transactions yet'))
                    : ListView.builder(
                      itemCount: _transactions.length,
                      itemBuilder: (context, index) {
                        final transaction = _transactions[index];
                        return ListTile(
                          title: Text(
                            '${transaction.amount} ${transaction.currency}',
                            style: TextStyle(
                              color:
                                  transaction.amount > 0
                                      ? Colors.red
                                      : Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                DateFormat.yMMMd().add_jm().format(
                                  transaction.date,
                                ),
                              ),
                              if (transaction.note != null &&
                                  transaction.note!.isNotEmpty)
                                Text(transaction.note!),
                            ],
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => _deleteTransaction(transaction),
                          ),
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
              builder:
                  (context) => AddTransactionPage(
                    debtorId: _debtor!.id,
                    currency: _debtor!.currency,
                  ),
            ),
          ).then((_) => _loadDebtorAndTransactions());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
