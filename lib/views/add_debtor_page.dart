// lib/views/add_debtor_page.dart
import 'package:flutter/material.dart';
import 'package:project_charon/model/debtor.dart';
import 'package:project_charon/services/database_service.dart';
import 'package:provider/provider.dart';
import 'package:appwrite/appwrite.dart';

class AddDebtorPage extends StatefulWidget {
  final String? userId;
  const AddDebtorPage({super.key, this.userId});

  @override
  State<AddDebtorPage> createState() => _AddDebtorPageState();
}

class _AddDebtorPageState extends State<AddDebtorPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _noteController = TextEditingController();
  String _selectedCurrency = 'IQD';
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _saveDebtor() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final databaseService = Provider.of<DatabaseService>(
          context,
          listen: false,
        );

        final debtor = Debtor(
          id: ID.unique(),
          name: _nameController.text.trim(),
          phoneNumber:
              _phoneController.text.isEmpty
                  ? null
                  : _phoneController.text.trim(),
          note:
              _noteController.text.isEmpty ? null : _noteController.text.trim(),
          currency: _selectedCurrency,
          currentBalance: 0,
          userId: widget.userId!, // Include the userId
        );

        await databaseService.createDebtor(debtor);

        if (mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Debtor added successfully')),
          );
        }
      } catch (e) {
        print('Error adding debtor: $e');
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Error adding debtor: $e')));
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
      appBar: AppBar(title: const Text('Add New Debtor')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone Number (optional)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedCurrency,
                decoration: const InputDecoration(
                  labelText: 'Currency',
                  border: OutlineInputBorder(),
                ),
                items:
                    ['IQD', 'USD'].map((currency) {
                      return DropdownMenuItem(
                        value: currency,
                        child: Text(currency),
                      );
                    }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCurrency = value!;
                  });
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
                onPressed: _isLoading ? null : _saveDebtor,
                child:
                    _isLoading
                        ? const CircularProgressIndicator()
                        : const Text('Save Debtor'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
