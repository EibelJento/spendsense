import 'package:flutter/material.dart';

import '../../data/models/transaction.dart';
import '../../data/repositories/transaction_repository.dart';
import '../../data/repositories/merchant_alias_repository.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({
    super.key,
    this.transaction,
    this.onSaved,
  });

  final TransactionModel? transaction;
  final Future<void> Function()? onSaved;

  @override
  State<AddTransactionScreen> createState() =>
      _AddTransactionScreenState();
}

class _AddTransactionScreenState
    extends State<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();

  final _merchantController = TextEditingController();
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();
  final MerchantAliasRepository _aliasRepository = MerchantAliasRepository();

  String _type = 'Expense';
  String _category = 'Food';
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();

    if (widget.transaction != null) {
      final transaction = widget.transaction!;
      _merchantController.text = transaction.merchant ?? '';
      _amountController.text = transaction.amount.toString();
      _notesController.text = transaction.notes;
      _type = transaction.type == TransactionType.income ? 'Income' : 'Expense';
      _category = transaction.category.isEmpty ? 'Food' : transaction.category;
      _selectedDate = transaction.date;
    }
  }

  final List<String> _categories = [
    'Food',
    'Transport',
    'Shopping',
    'Bills',
    'Entertainment',
    'Salary',
    'Other',
  ];

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2022),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _saveTransaction() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      final repository = TransactionRepository();
      final transaction = TransactionModel(
  id: widget.transaction?.id,
  amount: double.parse(_amountController.text),
  type: _type.toLowerCase() == 'income'
      ? TransactionType.income
      : TransactionType.expense,
  category: _category,
  date: _selectedDate,
  notes: _notesController.text.trim(),

  // Preserve existing values
  subcategory: widget.transaction?.subcategory,
  originalMerchant: widget.transaction?.originalMerchant,
  merchant: _merchantController.text.trim().isEmpty
    ? null
    : _merchantController.text.trim(),
  paymentMethod:
      widget.transaction?.paymentMethod ?? PaymentMethod.other,
  upiApp: widget.transaction?.upiApp,
  latitude: widget.transaction?.latitude,
  longitude: widget.transaction?.longitude,
  address: widget.transaction?.address,
  receiptImage: widget.transaction?.receiptImage,
  voiceNote: widget.transaction?.voiceNote,
  notificationId: widget.transaction?.notificationId,
  isAutoDetected:
      widget.transaction?.isAutoDetected ?? false,
  currency: widget.transaction?.currency ?? 'INR',
  tags: widget.transaction?.tags ?? const [],
  createdAt: widget.transaction?.createdAt,
  updatedAt: DateTime.now(),
);
      if (widget.transaction != null) {

  // Save alias if this was an auto-detected transaction
  if (widget.transaction!.originalMerchant != null &&
    widget.transaction!.originalMerchant!.isNotEmpty &&
    _merchantController.text.trim().isNotEmpty &&
    widget.transaction!.originalMerchant != _merchantController.text.trim()) {

  await _aliasRepository.saveAlias(
    merchantName: widget.transaction!.originalMerchant!,
    displayName: _merchantController.text.trim(),
  );
}

  await repository.updateTransaction(transaction);

} else {

  await repository.addTransaction(transaction);

}

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.transaction != null
                ? 'Transaction updated'
                : 'Transaction saved',
          ),
        ),
      );

      final canPop = Navigator.of(context).canPop();

      if (widget.onSaved != null) {
        await widget.onSaved!();
      }

      if (!mounted) return;

      if (canPop) {
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save transaction: $e')),
      );
    }
  }

  @override
  void dispose() {
    _merchantController.dispose();
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.transaction != null ? 'Edit Transaction' : 'Add Transaction',
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
  controller: _merchantController,
  decoration: const InputDecoration(
    labelText: "Merchant",
    border: OutlineInputBorder(),
    prefixIcon: Icon(Icons.person),
  ),
  validator: (value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter a merchant';
    }
    return null;
  }
),

            const SizedBox(height: 16),

            TextFormField(
              controller: _amountController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: "Amount",
                prefixText: "₹ ",
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter an amount";
                }

                if (double.tryParse(value) == null) {
                  return "Enter a valid number";
                }

                return null;
              },
            ),

            const SizedBox(height: 16),

            DropdownButtonFormField<String>(
              initialValue: _type,
              decoration: const InputDecoration(
                labelText: "Type",
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(
                  value: 'Expense',
                  child: Text('Expense'),
                ),
                DropdownMenuItem(
                  value: 'Income',
                  child: Text('Income'),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  _type = value!;
                });
              },
            ),

            const SizedBox(height: 16),

            DropdownButtonFormField<String>(
              initialValue: _category,
              decoration: const InputDecoration(
                labelText: "Category",
                border: OutlineInputBorder(),
              ),
              items: _categories.map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _category = value!;
                });
              },
            ),

            const SizedBox(height: 16),

            ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: const BorderSide(color: Colors.grey),
              ),
              title: const Text("Date"),
              subtitle: Text(
                "${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}",
              ),
              trailing: const Icon(Icons.calendar_today),
              onTap: _pickDate,
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: _notesController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: "Notes (Optional)",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 24),

            FilledButton.icon(
              onPressed: _saveTransaction,
              icon: const Icon(Icons.save),
              label: Text(
                widget.transaction != null ? 'Update Transaction' : 'Save Transaction',
              ),
            ),
          ],
        ),
      ),
    );
  }
}