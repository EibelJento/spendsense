import 'package:flutter/services.dart';

class ContinuousLocationManager {
  static const MethodChannel _channel =
      MethodChannel('spendsense/location');

  static Future<void> enable() async {
    await _channel.invokeMethod('startContinuousLocation');
  }

  static Future<void> disable() async {
    await _channel.invokeMethod('stopContinuousLocation');
  }

  static Future<bool> isEnabled() async {
    final bool? enabled = await _channel.invokeMethod<bool>(
      'isContinuousLocationEnabled',
    );

    return enabled ?? false;
  }
}