import 'package:flutter/material.dart';
import '../../services/location/continuous_location_manager.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _trackingEnabled = false;

  @override
  void initState() {
    super.initState();
    _loadState();
  }

  Future<void> _loadState() async {
    final enabled = await ContinuousLocationManager.isEnabled();

    setState(() {
      _trackingEnabled = enabled;
    });
  }

  Future<void> _toggleTracking(bool value) async {
    if (value) {
      await ContinuousLocationManager.enable();
    } else {
      await ContinuousLocationManager.disable();
    }

    setState(() {
      _trackingEnabled = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          const ListTile(
            title: Text('Currency'),
            trailing: Text('INR'),
          ),

          SwitchListTile(
            title: const Text('Continuous Location Tracking'),
            subtitle: const Text(
              'Keeps a foreground service running so SpendSense can attach your current location to SMS and notification transactions.',
            ),
            value: _trackingEnabled,
            onChanged: _toggleTracking,
          ),

          const ListTile(
            title: Text('Theme'),
            trailing: Text('System'),
          ),
        ],
      ),
    );
  }
}