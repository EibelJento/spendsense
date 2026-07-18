import 'package:flutter/material.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Analytics')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.pie_chart_outline, size: 64),
            const SizedBox(height: 12),
            Text('Spending insights', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            const Text('Charts and summaries will appear here.'),
          ],
        ),
      ),
    );
  }
}
