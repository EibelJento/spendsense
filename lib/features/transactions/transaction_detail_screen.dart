import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../data/models/transaction.dart';
import '../../services/location/location_service.dart';
import 'add_transaction_screen.dart';

class TransactionDetailScreen extends StatelessWidget {
  const TransactionDetailScreen({
    super.key,
    required this.transaction,
  });

  final TransactionModel transaction;

  Future<void> _openInGoogleMaps() async {
    if (transaction.latitude == null || transaction.longitude == null) {
      return;
    }

    final uri = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=${transaction.latitude},${transaction.longitude}',
    );

    await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              final result = await Navigator.push<bool>(
                context,
                MaterialPageRoute(
                  builder: (_) => AddTransactionScreen(
                    transaction: transaction,
                    onSaved: () async {},
                  ),
                ),
              );

              if (result == true && context.mounted) {
                Navigator.pop(context, true);
              }
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transaction.merchant ?? 'Unknown',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    transaction.displayAmount,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: transaction.type == TransactionType.income
                              ? Colors.green
                              : Colors.red,
                        ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          _DetailTile(
            label: 'Category',
            value: transaction.formattedCategory,
          ),
          _DetailTile(
            label: 'Date',
            value: transaction.formattedDate,
          ),
          _DetailTile(
            label: 'Notes',
            value: transaction.notes.isEmpty ? '—' : transaction.notes,
          ),
          _DetailTile(
            label: 'Merchant',
            value: transaction.merchant ?? '—',
          ),
          _DetailTile(
            label: 'Payment Method',
            value: transaction.paymentMethod.name,
          ),
          _DetailTile(
            label: 'Currency',
            value: transaction.currency,
          ),

          if (transaction.latitude != null &&
              transaction.longitude != null) ...[
            const Divider(height: 32),

            FutureBuilder<String?>(
              future: LocationService().getAddressFromCoordinates(
                transaction.latitude,
                transaction.longitude,
              ),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const _DetailTile(
                    label: 'Location',
                    value: 'Loading...',
                  );
                }

                return Column(
                  children: [
                    _DetailTile(
                      label: 'Location',
                      value: snapshot.data ?? 'Unknown location',
                    ),
                    _DetailTile(
                      label: 'Latitude',
                      value: transaction.latitude!.toStringAsFixed(6),
                    ),
                    _DetailTile(
                      label: 'Longitude',
                      value: transaction.longitude!.toStringAsFixed(6),
                    ),

                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        icon: const Icon(Icons.map),
                        label: const Text('View on Google Maps'),
                        onPressed: _openInGoogleMaps,
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ],
      ),
    );
  }
}

class _DetailTile extends StatelessWidget {
  const _DetailTile({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}