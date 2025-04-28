// lib/views/add_transaction_page.dart
import 'package:flutter/material.dart';
import 'package:project_charon/model/transaction.dart';
import 'package:project_charon/services/database_service.dart';
import 'package:provider/provider.dart';
import 'package:appwrite/appwrite.dart';

class AddTransactionPage extends StatefulWidget {
  final String debtorId;
  final String currency;

  const AddTransactionPage({
    super.key,
    required this.debtorId,
    required this.currency,
  });

  @override
  State<AddTransactionPage> createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends State<AddTransactionPage> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _saveTransaction() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final databaseService = Provider.of<DatabaseService>(
          context,
          listen: false,
        );

        final transaction = Transaction(
          id: ID.unique(), // This will be replaced when saved to Appwrite
          debtorId: widget.debtorId,
          amount: double.parse(_amountController.text.trim()),
          currency: widget.currency,
          note:
              _noteController.text.isEmpty ? null : _noteController.text.trim(),
          date: DateTime.now(),
        );

        await databaseService.createTransaction(transaction);

        if (mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Transaction added successfully')),
          );
        }
      } catch (e) {
        print('Error adding transaction: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error adding transaction: $e')),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add New Transaction')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _amountController,
                decoration: InputDecoration(
                  labelText: 'Amount (${widget.currency})',
                  border: const OutlineInputBorder(),
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an amount';
                  }
                  try {
                    double.parse(value);
                    return null;
                  } catch (e) {
                    return 'Please enter a valid number';
                  }
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _noteController,
                decoration: const InputDecoration(
                  labelText: 'Note (optional)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _saveTransaction,
                child:
                    _isLoading
                        ? const CircularProgressIndicator()
                        : const Text('Save Transaction'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
