package com.example.spendsense

import com.example.spendsense.location.ContinuousLocationManager
import com.example.spendsense.notification.bridge.NotificationEventChannel
import com.example.spendsense.notification.bridge.NotificationMethodChannel
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    companion object {
        const val EVENT_CHANNEL = "spendsense/notifications"
        const val METHOD_CHANNEL = "spendsense/notification_method"
        const val LOCATION_CHANNEL = "spendsense/location"
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // Notification Event Channel
        EventChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            EVENT_CHANNEL
        ).setStreamHandler(NotificationEventChannel)

        // Notification Method Channel
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            METHOD_CHANNEL
        ).setMethodCallHandler(
            NotificationMethodChannel(this)
        )

        // Continuous Location Method Channel
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            LOCATION_CHANNEL
        ).setMethodCallHandler { call, result ->

            when (call.method) {

                "startContinuousLocation" -> {
                    ContinuousLocationManager.enable(applicationContext)
                    result.success(true)
                }

                "stopContinuousLocation" -> {
                    ContinuousLocationManager.disable(applicationContext)
                    result.success(true)
                }

                "isContinuousLocationEnabled" -> {
                    result.success(
                        ContinuousLocationManager.isEnabled(applicationContext)
                    )
                }

                else -> {
                    result.notImplemented()
                }
            }
        }

        // Restart the service if it was previously enabled
        if (ContinuousLocationManager.isEnabled(applicationContext)) {
            ContinuousLocationManager.enable(applicationContext)
        }
    }
}