import 'package:flutter/material.dart';

import '../../core/extensions/date_time_extensions.dart';
import '../../data/models/transaction.dart';

class TransactionListTile extends StatelessWidget {
  const TransactionListTile({super.key, required this.transaction});

  final TransactionModel transaction;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        child: Icon(
          transaction.type == TransactionType.income
              ? Icons.arrow_downward
              : Icons.arrow_upward,
        ),
      ),
      title: Text(transaction.merchant ?? 'Unknown'),
      subtitle: Text('${transaction.category} • ${transaction.date.toDisplayDate()}'),
      trailing: Text(
        transaction.displayAmount,
        style: TextStyle(
          color: transaction.type == TransactionType.income
              ? Colors.green
              : Colors.red,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
