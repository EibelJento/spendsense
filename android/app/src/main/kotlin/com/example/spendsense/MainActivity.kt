package com.example.spendsense

import com.example.spendsense.notification.bridge.NotificationEventChannel
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import com.example.spendsense.notification.bridge.NotificationMethodChannel
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    companion object {
    const val EVENT_CHANNEL = "spendsense/notifications"
    const val METHOD_CHANNEL = "spendsense/notification_method"
}

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
    super.configureFlutterEngine(flutterEngine)

    EventChannel(
        flutterEngine.dartExecutor.binaryMessenger,
        EVENT_CHANNEL
    ).setStreamHandler(NotificationEventChannel)

    MethodChannel(
        flutterEngine.dartExecutor.binaryMessenger,
        METHOD_CHANNEL
    ).setMethodCallHandler(
        NotificationMethodChannel(this)
    )
}
}
