import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../data/models/transaction.dart';
import '../../data/repositories/transaction_repository.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  final TransactionRepository _repository = TransactionRepository();
  bool _isLoading = true;
  List<TransactionModel> _transactions = [];
  Map<String, double> _monthlySummary = {};
  Map<String, double> _categorySummary = {};
  double _income = 0;
  double _expense = 0;

  @override
  void initState() {
    super.initState();
    _loadAnalytics();
  }

  Future<void> _loadAnalytics() async {
    setState(() => _isLoading = true);

    try {
      final transactions = await _repository.getTransactions();
      final monthlySummary = await _repository.getMonthlySummary();
      final categorySummary = await _repository.getCategorySummary();
      final income = await _repository.getIncome();
      final expenses = await _repository.getExpenses();

      if (!mounted) return;

      setState(() {
        _transactions = transactions;
        _monthlySummary = monthlySummary;
        _categorySummary = categorySummary;
        _income = income.fold<double>(0, (sum, item) => sum + item.amount);
        _expense = expenses.fold<double>(0, (sum, item) => sum + item.amount);
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() => _isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load analytics: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Analytics')),
      body: RefreshIndicator(
        onRefresh: _loadAnalytics,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _AnalyticsCard(
              title: 'Monthly Spending',
              child: SizedBox(
                height: 220,
                child: LineChart(
                  LineChartData(
                    minY: 0,
                    lineBarsData: [
                      LineChartBarData(
                        spots: _monthlySummary.entries.toList().asMap().entries.map((entry) {
                          final index = entry.key.toDouble();
                          final value = entry.value.value;
                          return FlSpot(index, value);
                        }).toList(),
                        isCurved: true,
                        color: Theme.of(context).colorScheme.primary,
                        barWidth: 3,
                        dotData: const FlDotData(show: false),
                      ),
                    ],
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            final index = value.toInt();
                            final labels = _monthlySummary.keys.toList();
                            if (index >= 0 && index < labels.length) {
                              return Text(labels[index].split('-').last);
                            }
                            return const Text('');
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            _AnalyticsCard(
              title: 'Income vs Expense',
              child: SizedBox(
                height: 220,
                child: PieChart(
                  PieChartData(
                    sections: [
                      PieChartSectionData(
                        value: _income,
                        title: 'Income',
                        color: Colors.green,
                        radius: 70,
                      ),
                      PieChartSectionData(
                        value: _expense,
                        title: 'Expense',
                        color: Colors.red,
                        radius: 70,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            _AnalyticsCard(
              title: 'Category Breakdown',
              child: Column(
                children: _categorySummary.entries.toList().map((entry) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      children: [
                        Expanded(child: Text(entry.key)),
                        Text('\₹${entry.value.toStringAsFixed(2)}'),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),
            _AnalyticsCard(
              title: 'Top Spending Categories',
              child: Column(
                children: _categorySummary.entries
                    .where((entry) => entry.value > 0)
                    .toList()
                    .take(5)
                    .map((entry) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Row(
                          children: [
                            Expanded(child: Text(entry.key)),
                            Text('\$${entry.value.toStringAsFixed(2)}'),
                          ],
                        ),
                      );
                    })
                    .toList(),
              ),
            ),
            const SizedBox(height: 16),
            _AnalyticsCard(
              title: 'Recent Trends',
              child: Column(
                children: _transactions.take(5).map((transaction) {
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(transaction.title),
                    subtitle: Text(transaction.formattedDate),
                    trailing: Text(transaction.displayAmount),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AnalyticsCard extends StatelessWidget {
  const _AnalyticsCard({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}
