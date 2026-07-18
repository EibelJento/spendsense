import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';
import '../../data/models/transaction.dart';
import '../../data/repositories/transaction_repository.dart';
import '../../shared/widgets/empty_state.dart';
import '../../shared/widgets/summary_card.dart';
import '../../shared/widgets/transaction_list_tile.dart';
import '../transactions/add_transaction_screen.dart';
import '../transactions/transaction_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final TransactionRepository _repository = TransactionRepository();
  final List<TransactionModel> _transactions = [];
  double _currentBalance = 0;
  double _totalIncome = 0;
  double _totalExpense = 0;
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
      final totalIncome = await _repository.getIncome();
      final totalExpense = await _repository.getExpenses();
      final totalBalance = await _repository.getTotalBalance();

      if (!mounted) return;

      setState(() {
        _transactions
          ..clear()
          ..addAll(transactions);
        _totalIncome = totalIncome.fold<double>(0, (sum, item) => sum + item.amount);
        _totalExpense = totalExpense.fold<double>(0, (sum, item) => sum + item.amount);
        _currentBalance = totalBalance;
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

  Future<void> _deleteTransaction(TransactionModel transaction) async {
    final removed = transaction.copyWith();
    final repository = TransactionRepository();

    try {
      await repository.deleteTransaction(transaction.id!);
      await loadTransactions();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Transaction deleted'),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () async {
              await repository.addTransaction(removed);
              await loadTransactions();
            },
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete transaction: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.appTitle),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.filter_list)),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: loadTransactions,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Current Balance',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '\$${_currentBalance.toStringAsFixed(2)}',
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text('This month overview'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: SummaryCard(
                          title: 'Income',
                          value: '\$${_totalIncome.toStringAsFixed(2)}',
                          icon: Icons.arrow_downward,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: SummaryCard(
                          title: 'Expense',
                          value: '\$${_totalExpense.toStringAsFixed(2)}',
                          icon: Icons.arrow_upward,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Recent Transactions',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  if (_transactions.isEmpty)
                    const EmptyState(
                      title: 'No transactions yet',
                      message: 'Add your first transaction to start tracking your money.',
                    )
                  else
                    ..._transactions.map(
                      (item) => Dismissible(
                        key: ValueKey(item.id ?? item.title),
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        direction: DismissDirection.endToStart,
                        onDismissed: (_) => _deleteTransaction(item),
                        child: GestureDetector(
                          onTap: () async {
                            final result = await Navigator.push<bool>(
                              context,
                              MaterialPageRoute(
                                builder: (_) => TransactionDetailScreen(transaction: item),
                              ),
                            );

                            if (result == true) {
                              await loadTransactions();
                            }
                          },
                          child: TransactionListTile(transaction: item),
                        ),
                      ),
                    ),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddTransactionScreen,
        child: const Icon(Icons.add),
      ),
    );
  }
}
