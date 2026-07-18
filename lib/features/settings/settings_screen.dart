import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: const [
          ListTile(title: Text('Currency'), trailing: Text('USD')),
          ListTile(title: Text('Notifications'), trailing: Switch(value: true, onChanged: null)),
          ListTile(title: Text('Theme'), trailing: Text('System')),
        ],
      ),
    );
  }
}
