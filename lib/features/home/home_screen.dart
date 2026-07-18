import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';
import '../../core/utils/date_formatter.dart';
import '../../data/models/transaction.dart';
import '../transactions/add_transaction_screen.dart';
import '../transactions/repositories/transaction_repository.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final TransactionRepository _repository = TransactionRepository();
  final List<TransactionModel> _transactions = [];
  double _currentBalance = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    loadTransactions();
  }

  Future<void> loadTransactions() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final transactions = await _repository.getTransactions();

      if (!mounted) return;

      final totalIncome = transactions
          .where((transaction) => transaction.type == TransactionType.income)
          .fold(0.0, (sum, transaction) => sum + transaction.amount);

      final totalExpense = transactions
          .where((transaction) => transaction.type == TransactionType.expense)
          .fold(0.0, (sum, transaction) => sum + transaction.amount);

      setState(() {
        _transactions
          ..clear()
          ..addAll(transactions);
        _currentBalance = totalIncome - totalExpense;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load transactions: $e')),
      );
    }
  }

  Future<void> _openAddTransactionScreen() async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (context) => const AddTransactionScreen()),
    );

    if (result == true) {
      await loadTransactions();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.appTitle),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
          IconButton(
            onPressed: _openAddTransactionScreen,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Balance',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '\$${_currentBalance.toStringAsFixed(2)}',
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text('This month overview'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Recent transactions',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                if (_transactions.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Center(child: Text('No transactions yet')),
                  )
                else
                  ..._transactions.map((item) => ListTile(
                        leading: CircleAvatar(
                          child: Icon(
                            item.type == TransactionType.income
                                ? Icons.arrow_downward
                                : Icons.arrow_upward,
                          ),
                        ),
                        title: Text(item.title),
                        subtitle: Text(
                          '${item.category} • ${DateFormatter.format(item.date)}',
                        ),
                        trailing: Text(
                          item.displayAmount,
                          style: TextStyle(
                            color: item.type == TransactionType.income
                                ? Colors.green
                                : Colors.red,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )),
              ],
            ),
    );
  }
}
